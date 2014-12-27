#!/usr/bin/env ruby

#
# Originally adapted from evolutionary algorithm post here
# http://www.electricmonk.nl/log/2011/09/28/evolutionary-algorithm-evolving-hello-world/
#
class GeneticAlgorithm

	attr_accessor :target

	DEBUG = false
	GENSIZE = 20

	def initialize(source, target)

		puts "Created target of: #{target} from source: #{source}"
		@target = target
		@source = source
	end

	# Our population
	def generate_pool()

		@genepool = {}
		t_len = @target.length
		(0..GENSIZE - 1).each do |i|
			string = generate_string(t_len)
			puts "Generated: #{string}"
			fitness = calc_fitness(string)
			@genepool[fitness] = string
		end
	end

	def generate_string(target_length) 

		string = ""
		(0..(target_length - 1)).each do 
			char_idx = rand(32..126)
			string << char_idx.chr()
		end

		puts "string: #{string}"

		return string
	end

	def process()

		input = @source

		i = 0
		loop do

			# Use an elitist fitness ordered list within the genepool
			# Choose parents using a "uniform PRODUCT distribution" (0..1) then multiply both
			parent_one, parent_two = choose_parents()
			
			# Crossover
			parent_one, parent_two = crossover(parent_one, parent_two)

			# Mutation of parent one
			m_input = mutate(parent_one)
			m_fitness = calc_fitness(m_input)

			# Replace the weakest in the genepool with our new mutey-child
			weak_key = get_weakest()
			puts "Iteration: #{i} - replacing weakest: [#{weak_key}, #{sorted_gene_pool[weak_key]}]. Mutey: [#{m_input}, #{m_fitness}] size: #{@genepool.size()}"
			
			if m_fitness < weak_key.to_i

				@genepool.delete(weak_key)
				@genepool[m_fitness] = m_input
			end

			strongest = get_strongest()

			# If we've reached 0 then we're done
			if strongest.eql? 0 
				puts "\n ** Found target #{@target} from source: #{@source} in #{i} iterations **\n"
				break
			elsif strongest < 10
				# Hack to see the final stages of the algorithm
				sleep 0.1
			end

			if (i % 500).eql? 0
				puts "\nIteration: #{i}"		
				puts @genepool.size		
				weak_key = get_weakest()
				puts "500th iteration - Strongest: #{strongest} - #{sorted_gene_pool[strongest]}.  Weakest: #{weak_key} - #{sorted_gene_pool[weak_key]}" 
				display_genepool()
				sleep 2
			end

			i += 1
		end
	end

	def get_weakest()
		return sorted_gene_pool.keys[@genepool.size - 1]
	end

	def get_strongest()
		return sorted_gene_pool.keys[0]
	end

	def display_genepool()

		puts "Size: #{@genepool.size()}"
		text = ""
		i = 0
		sorted_gene_pool.each do |k, v|
			text += "#{i} - #{k} - [#{v}]\n"
			i += 1
		end
		puts "Gene Pool:\n#{text}"
	end

	def sorted_gene_pool()
		return Hash[@genepool.sort_by{|k, v| k}]
	end

	def choose_parents()

		genepool = sorted_gene_pool()

		# Choose a weighted random number and coerce to an integer
		weighted_random_number = (rand(0.0..1) * rand(0.0..1) * (@genepool.length - 1)).round
		parent_one = @genepool.keys[weighted_random_number]

		weighted_random_number = (rand(0.0..1) * rand(0.0..1) * (@genepool.length - 1)).round
		parent_two = @genepool.keys[weighted_random_number]

		puts "\nChose parents: #{parent_one} - #{@genepool[parent_one]} and #{parent_two} - #{@genepool[parent_two]}"

		return @genepool[parent_one], @genepool[parent_two]
	end


	def calc_fitness(input)

		fitness = 0
		input_chars = input.split("")
		target_chars = @target.split("")

		input_chars.each_with_index do |s, idx|
			t = target_chars[idx]			
			fitness += calc_char_diff(s, t)
		end

		puts "Mutated fitness: #{fitness} for #{input}" if DEBUG
		return fitness
	end

	def calc_char_diff(s, t)

		diff = 0
		if s > t
			diff = s.ord() - t.ord()
		else
			diff = t.ord() - s.ord()
		end

		puts "s: #{s} and t: #{t}" if DEBUG
		puts "Diff: #{diff}" if DEBUG
		return diff
	end

	def mutate(parent_one) 

		char_idx = rand(0..parent_one.length - 1)

		puts "parent_one: '#{parent_one}' target: '#{@target}' chartomutate: #{parent_one[char_idx]}, index: #{char_idx}" if DEBUG
		new_char = mutate_char(parent_one[char_idx])

		before = 0

		before = ""
		if char_idx > 0
			before = parent_one[0..(char_idx - 1)]
		end 

		after = ""
		if char_idx < parent_one.length
			after = parent_one[(char_idx + 1)..parent_one.length]
		end

		puts "New string: #{before}[#{new_char}]#{after}" if DEBUG
		return before + new_char + after
	end

	def crossover(parent_one, parent_two)

		child_dna = parent_one

		start = rand(0..parent_two.size)
		stop = rand(0..parent_two.size)

		while start.eql? stop or stop.eql? start do
			start = rand(0..parent_two.size)
		end

		# Swap the positions if we've generated them incorrectly
		if start > stop
			start, stop = stop, start
		end

		puts "\nGenerated positions: #{start} and #{stop}" if DEBUG

		child_sub = child_dna[start..stop]
		parent_sub = parent_two[start..stop]

		puts "Child sub: '#{child_sub}' - Parent sub '#{parent_sub}'" if DEBUG

		if start > 0		
			new_child_a = child_dna[0..start - 1] + parent_two[start..stop - 1] + child_dna[stop..child_dna.length]
			new_child_b = parent_two[0..start - 1] + child_dna[start..stop - 1] + parent_two[stop..parent_two.length]
		else
			new_child_a = parent_two[start..stop - 1] + child_dna[stop..child_dna.length]
			new_child_b = child_dna[start..stop - 1] + parent_two[stop..parent_two.length]
		end

		puts "Parent one: '#{parent_one}' Parent two: '#{parent_two}'" if DEBUG
		puts "New child A: '#{new_child_a}' New child B: '#{new_child_b}'" if DEBUG

		return new_child_a, new_child_b
	end

	def mutate_char(c) 

		change_value = rand(-1..1)
		new_value = c.ord + change_value
		return new_value.chr()
	end

end

source = "jiKnp4bqpmA"
ga = GeneticAlgorithm.new(source, "Hello World")
ga.generate_pool()
ga.process()