require 'rubygems'

require 'voter-registration-client'
 
 VoterRegApi::Client.api_key = '' #get an api key from lockbox.dnc.org
 
 !VoterRegApi::Client.api_key.blank? || (puts("get an api key from lockbox.dnc.org"))
 
 attrs = {"previous_address_street"=>nil,
  "name_middle"=>'James',
  "previous_name_suffix"=>nil,
  "created_at"=>DateTime.now,
  "email_optin"=>true,
  "name_last"=>'Smith',
  "id_sha1"=>nil,
  "birthdate"=>Date.parse("01-01-1970"),
  "previous_name_last"=>nil,
  "ethnicity"=>nil,
  "previous_name_middle"=>nil,
  "previous_name_title"=>nil,
  "mailing_address_street"=>nil,
  "id_number"=>1234567,
  "temp_id_number"=>1234567,
  "gender"=>'Male',
  "address_zipcode"=>'12345',
  "address_street"=>'4 Monkey ln',
  "referer"=>nil,
  "previous_name_first"=>nil,
  "political_party"=>nil,
  "mailing_address_zipcode"=>nil,
  "phone_number"=>'(223) 222-3434',
  "name_title"=>'Mr.',
  "previous_address_county"=>nil,
  "mailing_address_state"=>nil,
  "mailing_address_city_town"=>nil,
  "name_suffix"=>nil,
  "previous_address_zipcode"=>nil,
  "ip"=>nil,
  "i18n"=>'en',
  "address_state"=>'NY',
  "name_first"=>'John',
  "name_change"=>false,
  "citizen"=>true,
  "link"=>nil,
  "source"=>nil,
  "address_city_town"=>'General Electric',
  "sms_optin"=>false,
  "previous_address_state"=>nil,
  "email"=>'jjsmith@bobmail.info',
  "address_county"=>nil,
  "previous_address_city_town"=>nil}

registration = VoterRegApi::Registration.create(attrs)
puts registration.pdf_link