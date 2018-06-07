class UserSetting < ApplicationRecord
	serialize :settings
	serialize :friends
end