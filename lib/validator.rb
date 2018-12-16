class Validator
	def self.err_check(page, params)
		if page == :earn
			errHash = {:date => 'Поле с датой пустое',
			:sourse => 'Поле с источником дохода пустое',
			:username => 'Поле с именем пустое',
			:amount => 'Поле с суммой пустое'}
		elsif page == :fact_payment
			errHash = {:sourse => 'Поле с причиной расхода пустое',
			:date => 'Поле с датой пустое',
			:username => 'Поле с именем пустое',
			:amount => 'Поле с суммой пустое'}
		elsif page == :planned_payment
			errHash = {:sourse => 'Поле с причиной расхода пустое',
			:amount => 'Поле с суммой пустое'}
		elsif page == :log_in
			errHash = {:username => 'Кхм-кхм, может все же введешь имя?'}				
		end
			return errHash.select{|key| params[key] == ''}.values.join('|')
	end
end