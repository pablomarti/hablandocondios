module ApplicationHelper

	def item_active(value)
		value ? t('yes') : t('no')
	end

	def get_gender(value)
		value ? t('male') : t('female')
	end

	def is_admin
		current_user && current_user.is_admin?
	end

	def format_to_br(text)
		raw(text.gsub(/\n/, '<br>'))
	end
	
end
