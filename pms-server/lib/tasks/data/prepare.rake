namespace :data do
  desc 'clean data'
  task :reset => :environment do
    %w(db:drop db:create db:migrate).each do |task|
      puts "executing #{task}..."
      Rake::Task[task].invoke
    end
  end

  desc 'prepare parts'
  task :part => :environment do
    ('A'..'Z').each do |nr|
      puts nr
      part= Part.create(nr: nr)
      puts part.errors.as_json
    end
  end

  # A B,C
  # B D,E
  # C F,G
  # H B,F
  desc 'prepare part bom'
  task :part_bom => :environment do
    PartBom.destroy_all

    bom={A: %w(B C H), B: %w(D E), C: %w(F G), H: %w(B F)}
    bom.each do |k, v|
      p=Part.find_by_nr(k.to_s)
      v.each do |vv|
        p.part_boms.create(bom_item_id: Part.find_by_nr(vv).id, quantity: rand(10))
      end
    end
  end
end