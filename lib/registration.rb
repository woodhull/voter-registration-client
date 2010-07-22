module VoterRegApi
  class Registration < Client
    POST_FIELDS = ["address_city_town", "address_street", "address_county", "address_zipcode", "birthdate", "email", "phone_number", "gender", "mailing_address_city_town", "mailing_address_state", "mailing_address_street", "mailing_address_zipcode", "name_change", "name_first", "name_last", "name_middle", "name_suffix", "political_party", "previous_address_city_town", "previous_address_county", "previous_address_city_town", "previous_address_street", "previous_address_zipcode", "previous_name_first", "previous_name_last", "previous_name_middle", "previous_name_suffix",  "address_state", "ethnicity", "temp_id_number", "name_title",  "previous_address_state", "previous_name_title", "email_optin", "sms_optin", "i18n", "ip", "referer",  "citizen", "source"]

    OTHER_FIELDS = %w{link id_sha1 id_number created_at}
    FIELDS = POST_FIELDS + OTHER_FIELDS

    attr_accessor *FIELDS

    def initialize(args = {})
      self.attributes = args
      if self.address_state && !self.address_state.blank?
        @fields = Field.find(address_state, i18n)
      else
        @fields = []
      end
      @errors      =  {}
      # check only email by default
      @email_optin = @email_optin.nil? ? true : @email_optin
      @sms_optin   = @sms_optin.nil? ? false : @sms_optin
    end

    def id
      self.id_sha1
    end

    def update_attributes(attributes)
      self.attributes = attributes
      self.attributes = attributes.merge(VoterRegApi::Registration.put("/registrations/#{id_sha1}.json", :headers => {"Content-Length" => "0"}, :query => {:registration => self.to_hash}))
      if self.valid?
        return self
      else
        return false
      end
    end

    def self.create(args = {})
      registration = Registration.new(args)
      registration.attributes = post("/api/registrations.json?key=#{api_key}", :query => {:registration => registration.to_hash})
      registration
    end

    def self.find(id_sha1)
      response = get("/registrations/#{id_sha1}.json")
      if response.code.to_i == 200
        Registration.new(response)
      else
        raise RecordNotFound
      end
    end

    def self.find_by_email(email)
      response = get(URI.escape("/registrations/email?email=#{email}"))
      if response.code.to_i == 200
        response.code.to_i
      else
        raise RecordNotFound
      end
    end

    def new_record?
      if  id_sha1.blank?
        return true
      else
        return false
      end
    end
  

    def string_to_boolean(string)
      return nil if string.blank?
      str = string.downcase
      if str =~ /^(?:f(?:alse))$/ ||
        str =~ /^(?:n(?:o))$/ ||
        str == "0"
        return false
      end
      true
    end

    def email_optin=(value)
      if value.class == String
        @email_optin = string_to_boolean(value)
      else
        @email_optin = value
      end
    end

    def sms_optin=(value)
      if value.class == String
        @sms_optin = string_to_boolean(value)
      else
        @sms_optin = value
      end
    end

    def to_hash
      result = {}
      POST_FIELDS.each do | field |
        result[field] = self.send(field)
      end
      result
    end

    def attributes=(args = {})
      args.each do | key, value |
        if self.respond_to?("#{key.to_s}=")
          self.send("#{key.to_s}=", value)
        end
      end
    end

    def errors=(error_hash)
      @errors = error_hash
    end

    def errors
      @errors
    end

    def fields
      @fields
    end

    def attribute_required?(field)
      if attribute = @fields.detect { |e| !e[Fields::Unsupported] && e.name.to_s == field.to_s }
        attribute.validations.has_key?('required')
      else
        false
      end
    end

    def inspect
      r = FIELDS.inject({}) do | hash, field |
        hash.merge( field => self.send(field) )
      end
      r.inspect
    end

    def valid?
      !self.errors.any? && !self.link.blank?
    end

  end
end

class RecordNotFound < Exception
end
