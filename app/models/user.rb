class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, presence: true, length: { minimum: 8 },
                       format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+\z/,
                                 message: "must include at least one lowercase letter, one uppercase letter, one digit, and one special character" },
                       if: :password_digest_changed?
end