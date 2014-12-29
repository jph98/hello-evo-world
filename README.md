Hello Evo World
===============

Organism has a set of RULES encoded in the genes, constructed into strings called chromosomes
* Genotype - genes (hair colour) and settings (blonde, brown etc...)
* Phenotype - physical expression of the genotype

Recombination - genes from parents combined for the offspring.  Occasionally a gene mutates.

Chromosome - 10010101110101001010011101101110111111101

* Test each and assign a fitness score to the chromosome
* Select the best members of the population using Roulette Wheel Selection (think pie chart where fitter members of the population occupy more space)
* Using the Crossover Rate crossover the bits from the chosen chromosome at a random point (e.g. 0.7)
* Step through the chromosomes bits and flip based on the Mutation Rate
* Repeat until a new population of N members has been created

There's two basic implementations in Ruby adapted from the original Python code:
* Simple one organism example
* Evolutionary example with a genepool of size 20

Both of these use a very basic mutation of a set of characters in a string and iterate towards an end goal of "Hello World".  The latter incorporates uniform product distribution and a weighted hash of fitness -> String to maintain a topscore.

Also see:

http://www.reddit.com/r/programming/comments/ktg7o/evolutionary_algorithm_evolving_hello_world/
https://news.ycombinator.com/item?id=3047046
