class UserSetting < ApplicationRecord
	serialize :settings
	serialize :friends
	serialize :contests
end