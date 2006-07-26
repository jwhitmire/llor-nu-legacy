begin		
	ActiveRecord::Base.connection.execute("show fields from mem_users")
rescue
	if RAILS_ENV == 'development'
		results = `mysql llor --user=root --password= < #{RAILS_ROOT}/script/mem_tables.sql`
	else
		results = `mysql llor --user=root --password= < #{RAILS_ROOT}/script/mem_tables.sql`
	end
end
