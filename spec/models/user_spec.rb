# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#  admini             :boolean
#

require 'spec_helper'

describe User do
  
  before (:each) do
    
    @attr ={:name => "Example User" , 
            :email => "user@example.com" ,
            :password => "foobar" ,
            :password_confirmation=> "foobar"
           }
    
  end
  
  it"should create a new instance given a valid attributes" do
   User.create!(@attr)
  end
  
  # Length validation
  it "should require a name " do
     no_name_user = User.new(@attr.merge(:name => ""))
     no_name_user.should_not be_valid
  end 
  
  it "should require an email " do
     no_email_user = User.new(@attr.merge(:email => ""))
     no_email_user.should_not be_valid
  end
  
  it"should reject names that are too long" do
    
    long_name = 'a' * 51
    long_name_user=User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
    
  end
  
  #format validation
  
  it "should accept valid email adresses" do
    
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      
      valid_eamil_user = User.new(@attr.merge(:email => address))
      valid_eamil_user.should be_valid
      
    end  
  end  
  
  it "should reject invalid email adresses" do
    
    addresses = %w[user@foo,com THE_USERfoo.bar.org first.last@foo.]
    addresses.each do |address|
      
      invalid_eamil_user = User.new(@attr.merge(:email => address))
      invalid_eamil_user.should_not be_valid
      
    end  
  end
  
  #uniquness validation
  
  it"should reject duplicate email adressess" do
    User.create!(@attr)
    user_duplicate_email= User.new(@attr)
    user_duplicate_email.should_not be_valid
  end  
  
  it"should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end  
  
  #passwords validations
  
  describe "password validations" do
    it "should require a password" do
      no_password_user = User.new(@attr.merge(:password =>"" , :password_confirmation => ""))
      no_password_user.should_not be_valid
      
    end
    
    it "should have a matching password" do
      no_matching_password_user = User.new(@attr.merge(:password_confirmation => "invalid"))
      no_matching_password_user.should_not be_valid
      
    end  
    
    
    it " should not have short passwords" do
      short_password = 'a' * 5
      short_password_user = User.new(@attr.merge(:password =>short_password , :password_confirmation => short_password))
      short_password_user.should_not be_valid
      
    end
    
     it " should not have long passwords" do
        long_password = 'a' * 41
        long_password_user = User.new(@attr.merge(:password =>long_password , :password_confirmation => long_password))
        long_password_user.should_not be_valid

      end
    
  end
  
  describe "password encryption" do
     before (:each) do
       @user = User.create!(@attr)
     end
     
     it "should have an encrypted password attribute" do
       @user.should respond_to(:encrypted_password)
     end
     it "should not be black" do
       @user.encrypted_password.should_not be_blank
     end
     
     describe "has_ password method" do
        it "should be true if the user passwords match" do
           @user.has_password?(@attr[:password]).should be_true
        end
        
        it "should be false if the passwords dont match" do
           @user.has_password?("invalid").should be_false
        end 
     
     describe "authonticate method" do
       it"should return nil if email/password missmatch" do
         wrong_password_user= User.authenticate(@attr[:email] ,"wrongpass")
         wrong_password_user.should be_nil
      end
      
       it"should return nil email/password with no user" do
         wrong_password_user= User.authenticate("boo@foo.com" ,@attr[:password])
         wrong_password_user.should be_nil
       end
       
       it"should return the user email/password match " do
          wrong_password_user= User.authenticate(@attr[:email],@attr[:password])
          wrong_password_user.should == @user
        end
      end
      end
    end  
    describe "admin attribute" do

        before(:each) do
          @user = User.create!(@attr)
        end

        it "should respond to admin" do
          @user.should respond_to(:admin)
        end

        it "should not be an admin by default" do
          @user.should_not be_admin
        end

        it "should be convertible to an admin" do
          @user.toggle!(:admin)
          @user.should be_admin
        end
      end
end
