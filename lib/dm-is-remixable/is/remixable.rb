module DataMapper
  module Is
    module Remixable

      #==============================INCLUSION METHODS==============================#

      # Adds remixer methods to DataMapper::Resource
      def self.included(base)
        base.send(:include,RemixerClassMethods)
        base.send(:include,RemixerInstanceMethods)
      end

      # - is_remixable
      # ==== Description
      #   Adds RemixeeClassMethods and RemixeeInstanceMethods to any model that is: remixable
      # ==== Examples
      # class User #Remixer
      #   remixes Commentable
      #   remixes Vote
      # end
      #
      # module Commentable #Remixable
      #   include DataMapper::Resource
      #
      #   is :remixable,
      #     :suffix => "comment"
      # end
      #
      # module Vote #Remixable
      #   include DataMapper::Resource
      #
      #   is :remixable
      #
      # ==== Notes
      #   These options are just available for whatever reason your Remixable Module name
      #   might not be what you'd like to see the table name and property accessor named.
      #   These are just configurable defaults, upon remixing the class_name and accessor there
      #   take precedence over the defaults set here
      # ==== Options
      #   :suffix   <String>
      #             Table suffix, defaults to YourModule.name.downcase.singular
      #             Yields table name of remixer_suffix; ie user_comments, user_votes
      def is_remixable(options={})
        extend  DataMapper::Is::Remixable::RemixeeClassMethods
        include DataMapper::Is::Remixable::RemixeeInstanceMethods

        suffix(options.delete(:suffix) || self.name.downcase.singular)
      end


      #==============================CLASS METHODS==============================#

      # - RemixerClassMethods
      # ==== Description
      #   Methods available to all DataMapper::Resources
      module RemixerClassMethods
        def self.included(base);end;

        # - remixables
        # ==== Description
        #   Returns a hash of the remixables used by this class
        # ==== Returns
        #   <Hash> Remixable Class Name => Remixed Class Name
        def remixables
          @remixables
        end

        # - remix
        # ==== Description
        #   Remixes a Remixable Module
        # ==== Parameters
        #   cardinality <~Fixnum> 1, n, x ...
        #   remixable   <Symbol> plural of remixable; i.e. Comment => :comments
        #   options     <Hash>   options hash
        #                       :class_name <String> Remixed Model name (Also creates a storage_name as tableize(:class_name))
        #                                   This is the class that will be created from the Remixable Module
        #                                   The storage_name can be changed via 'enhance' in the class that is remixing
        #                                   Default: self.name.downcase + "_" + remixable.suffix.pluralize
        #                       :as         <String> Alias to access associated data
        #                                   Default: tableize(:class_name)
        #                       :for|:on    <String> Class name to join to through Remixable
        #                                   This will create a M:M relationship THROUGH the remixable, rather than
        #                                   a 1:M with the remixable
        #                       :via        <String> changes the name of the second id in a unary relationship
        #                                   see example below; only used when remixing a module between the same class twice
        #                                   ie: self.class.to_s == options[:for||:on]
        #                       :unique     <Boolean> Only works with :for|:on; creates a unique composite key
        #                                   over the two table id's
        # ==== Examples
        # Given: User (Class), Addressable (Module)
        #
        #   One-To-Many; Class-To-Remixable
        #
        #   remix n, :addressables,
        #     :class_name => "UserAddress",
        #     :as         => "addresses"
        #
        #   Tables: users, user_addresses
        #   Classes: User, UserAddress
        #     User.user_addresses << UserAddress.new
        #     User.addresses << UserAddress.new
        #   --------------------------------------------
        #   --------------------------------------------
        #
        # Given: User (Class), Video (Class), Commentable (Module)
        #
        #   Many-To-Many; Class-To-Class through RemixableIntermediate (Video allows Commentable for User)
        #
        #   Video.remix n, :commentables
        #     :for        => 'User'    #:for & :on have same effect, just a choice of wording...
        #   --------------------------------------------
        #   --------------------------------------------
        #
        # Given: User (Class), User (Class), Commentable (Module)
        #
        #   Many-To-Many Unary relationship between User & User through comments
        #   User.remix n, :commentables, :as => "comments", :for => 'User', :via => "commentor"
        #   => This would create user_id and commentor_id as the
        #
        def remix(cardinality, remixable, options={})
          #A map for remixable names to Remixed Models
          @remixables = {} if @remixables.nil?

          remixable_module = Object.const_get(Extlib::Inflection.classify(remixable))

          #Merge defaults/options
          options = {
            :as         => nil,
            :class_name => Extlib::Inflection.classify(self.name + "_" + remixable_module.suffix.pluralize),
            :for        => nil,
            :on         => nil,
            :unique     => false,
            :via        => nil
          }.merge(options)

          #Make sure the class hasn't been remixed already
          unless Object.const_defined? options[:class_name]

            #Storage name of our remixed model
            options[:table_name] = Extlib::Inflection.tableize(options[:class_name])

            #Other model to mix with in case of M:M through Remixable
            options[:other_model] = options[:for] || options[:on]

            puts " ~ Generating Remixed Model: #{options[:class_name]}"
            model = generate_remixed_model(remixable_module, options)

            #map the remixable to the remixed model
            @remixables[remixable] = model

            #Create relationships between Remixer and remixed class
            if options[:other_model]
              # M:M Class-To-Class w/ Remixable Module as intermediate table
              # has n and belongs_to (or One-To-Many)
              remix_many_to_many cardinality, model, options
            else
              # 1:M Class-To-Remixable
              # has n and belongs_to (or One-To-Many)
              remix_one_to_many cardinality, model, options
            end

            #Add accessor alias
            attach_accessor(options) unless options[:as].nil?
          else
            puts "#{__FILE__}:#{__LINE__} warning: already remixed constant #{options[:class_name]}"
          end
        end

        # - enhance
        # ==== Description
        #   Enhance a remix; allows nesting remixables, adding columns & functions to a remixed resource
        # ==== Parameters
        #   remixable <Symbol> Name of remixable to enhance
        #   block     <Proc>    Enhancements to perform
        # ==== Examples
        #   class Video
        #     include DataMapper::Resource
        #     remix Comment
        #
        #     enhance :comments do
        #       remix n, :votes        #This would result in something like YouTubes Voting comments up/down
        #
        #       property :updated_at, DateTime
        #
        #       def backwards; self.test.reverse; end;
        #     end
        def enhance(remixable,&block)
          model = @remixables[remixable]

          unless model.nil?
            model.class_eval &block
          else
            raise Exception, "#{remixable} must be remixed before it can be enhanced"
          end
        end

        private

        # - attach_accessor
        # ==== Description
        #   Creates additional alias for r/w accessor
        # ==== Parameters
        #   options <Hash> options hash
        def attach_accessor(options)
          self.class_eval(<<-EOS, __FILE__, __LINE__ + 1)
            alias #{options[:as].intern} #{options[:table_name].intern}
            alias #{options[:as].intern}= #{options[:table_name].intern}=
          EOS
        end

        # - remix_one_to_many
        # ==== Description
        #   creates a one to many relationship Class has many of remixed model
        # ==== Parameters
        #   cardinality <Fixnum> cardinality of relationship
        #   model       <Class> remixed model that 'self' is relating to
        #   options     <Hash> options hash
        def remix_one_to_many(cardinality, model, options)
          self.has cardinality, options[:table_name].intern
          model.belongs_to Extlib::Inflection.tableize(self.name).intern
        end

        # - remix_many_to_many
        # ==== Description
        #   creates a many to many relationship between two DataMapper models THROUGH a Remixable module
        # ==== Parameters
        #   cardinality <Fixnum> cardinality of relationship
        #   model       <Class> remixed model that 'self' is relating through
        #   options     <Hash> options hash
        def remix_many_to_many(cardinality, model, options)
          options[:other_model] = Object.const_get options[:other_model]

          #TODO if options[:unique] the two *_id's need to be a unique composite key, maybe even
          # attach a validates_is_unique if the validator is included.
          puts " ~ options[:unique] is not yet supported" if options[:unique]

          # Is M:M between two different classes or the same class
          unless self.name == options[:other_model].name
            self.has cardinality, options[:table_name].intern
            options[:other_model].has cardinality, options[:table_name].intern

            model.belongs_to  Extlib::Inflection.tableize(self.name).intern
            model.belongs_to  Extlib::Inflection.tableize(options[:other_model].name).intern
          else
            raise Exception, "options[:via] must be specified when Remixing a module between two of the same class" unless options[:via]

            self.has cardinality, options[:table_name].intern
            model.belongs_to Extlib::Inflection.tableize(self.name).intern
            model.belongs_to options[:via].intern, :class_name => options[:other_model].name, :child_key => ["#{options[:via]}_id".intern]
          end
        end

        # - generate_remixed_model
        # ==== Description
        #   Generates a Remixed Model Class from a Remixable Module and options
        # ==== Parameters
        #   remixable <Module> module that is being remixed
        #   options   <Hash> options hash
        # ==== Returns
        #   <Class> remixed model
        def generate_remixed_model(remixable,options)
          #Create Remixed Model
          klass = Class.new Object do
            include DataMapper::Resource
          end

          #Give remixed model a name and create its constant
          model = Object.const_set options[:class_name], klass

          #Get instance methods & validators
          model.send(:include,remixable)

          #port the properties over...
          remixable.properties.each do |prop|
            model.property(prop.name, prop.type, prop.options)
          end

          model
        end

      end # RemixerClassMethods

      # - RemixeeClassMethods
      # ==== Description
      #   Methods available to any model that is :remixable
      module RemixeeClassMethods
        # - suffix
        # ==== Description
        #   modifies the storage name suffix, which is by default based on the Remixable Module name
        # ==== Parameters
        #   suffix <String> storage name suffix to use (singular)
        def suffix(sfx=nil)
          @suffix = sfx unless sfx.nil?
          @suffix
        end

        #Squash auto_migrate!
        def auto_migrate!(args=nil)
          DataMapper.logger.warn("Remixable modules (#{self.name}) cannot be auto migrated")
        end

        #Squash auto_upgrade!
        def auto_upgrade!(args=nil)
          DataMapper.logger.warn("Remixable modules (#{self.name}) cannot be auto updated")
        end
      end # RemixeeClassMethods


      #==============================INSTANCE METHODS==============================#

      module RemixeeInstanceMethods
        def self.included(base);end;
      end # RemixeeInstanceMethods

      module RemixerInstanceMethods
        def self.included(base);end;
      end # RemixerInstanceMethods

    end # Example
  end # Is
end # DataMapper
