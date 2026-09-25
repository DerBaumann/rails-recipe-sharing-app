# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning database..."
ActivityLog.destroy_all if defined?(ActivityLog)
Comment.destroy_all
Favourite.destroy_all
Ingredient.destroy_all
Recipe.destroy_all
User.destroy_all

puts "Creating users..."
admin = User.create!(
  email_address: 'admin@test.com',
  password: 'P4ssw0rd!',
  role: 'admin'
)

member1 = User.create!(
  email_address: 'member1@test.com',
  password: 'P4ssw0rd!',
  role: 'member'
)

member2 = User.create!(
  email_address: 'member2@test.com',
  password: 'P4ssw0rd!',
  role: 'member'
)

puts "Creating recipes..."

# Recipe 1: Spaghetti Carbonara (Member 1)
carbonara = Recipe.create!(
  title: 'Klassische Spaghetti Carbonara',
  instructions: "1. Spaghetti in reichlich Salzwasser al dente kochen.\n2. Guanciale/Speck in einer Pfanne knusprig anbraten.\n3. Eigelb mit frisch geriebenem Pecorino und Pfeffer verrühren.\n4. Pasta direkt aus dem Wasser zum Speck geben, vom Herd nehmen und die Eimischung mit etwas Pastawasser schnell unterrühren.",
  prep_time_minutes: 20,
  is_published: true,
  user: member1
)

carbonara.ingredients.create!([
  { name: 'Spaghetti', amount: 400, unit: 'g' },
  { name: 'Guanciale oder Pancetta', amount: 150, unit: 'g' },
  { name: 'Eigelb', amount: 4, unit: 'Stück' },
  { name: 'Pecorino Romano', amount: 80, unit: 'g' },
  { name: 'Schwarzer Pfeffer', amount: 1, unit: 'Prise' }
])

# Recipe 2: Avocado Toast (Member 2)
avocado_toast = Recipe.create!(
  title: 'Avocado Toast mit pochiertem Ei',
  instructions: "1. Brot rösten.\n2. Avocado zerdrücken und mit Zitronensaft, Salz und Pfeffer abschmecken.\n3. Wasser mit einem Schuss Essig erhitzen, Wirbel erzeugen und Ei darin 3 Minuten pochieren.\n4. Avocado auf das Brot streichen und das Ei darauf platzieren.",
  prep_time_minutes: 15,
  is_published: true,
  user: member2
)

avocado_toast.ingredients.create!([
  { name: 'Sauerteigbrot', amount: 2, unit: 'Scheiben' },
  { name: 'Reife Avocado', amount: 1, unit: 'Stück' },
  { name: 'Eier', amount: 2, unit: 'Stück' },
  { name: 'Zitronensaft', amount: 1, unit: 'TL' },
  { name: 'Chiliflocken', amount: 0.5, unit: 'TL' }
])

# Recipe 3: Entwurf (Member 1)
Recipe.create!(
  title: 'Geheimes Schokoladen-Mousse',
  instructions: "Rezept noch in Überarbeitung...",
  prep_time_minutes: 45,
  is_published: false,
  user: member1
)

puts "Creating comments & ratings..."
Comment.create!(
  recipe: carbonara,
  author: member2,
  title: 'Traumhaftes Rezept!',
  body: 'Sehr authentisch ohne Sahne! Genau so muss eine echte Carbonara schmecken.',
  rating: 5
)

Comment.create!(
  recipe: avocado_toast,
  author: member1,
  title: 'Schnell und lecker',
  body: 'Perfekt fürs Sonntagsfrühstück. Hat super geklappt.',
  rating: 4
)

puts "Creating favourites..."
Favourite.create!(user: member1, recipe: avocado_toast)
Favourite.create!(user: member2, recipe: carbonara)

puts "Seeding finished successfully!"
puts "Created #{User.count} users, #{Recipe.count} recipes, #{Ingredient.count} ingredients, and #{Comment.count} comments."
