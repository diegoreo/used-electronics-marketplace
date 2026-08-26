namespace :admin do
  desc "Promueve un usuario existente a admin: rails admin:promote[email@ejemplo.com]"
  task :promote, [:email] => :environment do |_, args|
    abort "Uso: rails admin:promote[email@ejemplo.com]" if args[:email].blank?

    user = User.find_by(email: args[:email].downcase)
    abort "No existe ningún usuario con el email #{args[:email]}" unless user

    user.update!(admin: true)
    puts "#{user.username} (#{user.email}) ahora es admin."
  end
end
