class User < ApplicationRecord
    attr_accessor :password
    #attr_accessible :username, :email, :password, :password_confirmation
    EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i 
    validates :name, :presence => true, :length => { :in => 3..20 }
    validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
    validates :password, :confirmation => true #password_confirmation attr
    validates_length_of :password, :in => 6..20, :on => :createUser

    before_save :encrypt_password
    after_save :clear_password
    def encrypt_password
        if password.present?
            self.encrypted_password=BCrypt::Password.create(password) 
        end
    end
    def clear_password
        self.password = nil
    end
end
