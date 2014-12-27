#!/usr/bin/env ruby

class GeneticAlgorithm

	attr_accessor :target

	DEBUG = false

	def initialize(source, target)

		puts "Created target of: #{target} from source: #{source}"
		@target = target
		@source = source
	end

	def process()

		input = @source
		fitness = 10000

		i = 0
		loop do

			mutated_input = mutate(input, fitness)
			mutated_fitness = calc_fitness(mutated_input)
			puts "Mutated string #{mutated_input} mutated fitness: #{mutated_fitness} fitness: #{fitness} iteration: #{i}" if DEBUG

			if mutated_fitness < fitness
				puts "Mutated string GOOD" if DEBUG
				input = mutated_input
				fitness = mutated_fitness
			else
				puts "Mutated string BAD. Discard." if DEBUG
			end

			if fitness.eql? 0
				puts "Found target string #{@target} from source: #{@source} in #{i} iterations"
				break
			elsif fitness < 10
				sleep 0.02
			end

			i += 1
		end
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

	def mutate(input, fitness) 

		char_idx = rand(0..input.length - 1)

		puts "input: '#{input}' target: '#{@target}' char to mutate: #{input[char_idx]}, index: #{char_idx}, fitness: #{fitness}"
		new_char = mutate_char(input[char_idx])

		before = 0

		before = ""
		if char_idx > 0
			before = input[0..(char_idx - 1)]
		end 

		after = ""
		if char_idx < input.length
			after = input[(char_idx + 1)..input.length]
		end

		puts "New string: #{before}[#{new_char}]#{after}" if DEBUG
		return before + new_char + after
	end

	def mutate_char(c) 

		change_value = rand(-1..1)
		new_value = c.ord + change_value
		return new_value.chr()
	end

end

source = "jiKnp4bqpmA"
ga = GeneticAlgorithm.new(source, "Hello World")
ga.process()