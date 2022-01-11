class Movie
  REGULAR = 0
  NEW_RELEASE = 1
  CHILDRENS = 2

  attr_reader :title
  attr_accessor :price_code

  def initialize(title, price_code, strategy)
    @title = title
    @price_code = price_code
    @strategy = strategy
  end

  def flat_fee
    @strategy.flat_fee
  end

  def daily_fee
    @strategy.daily_fee
  end

  def days_free
    @strategy.days_free
  end

  def eligible_for_bonus_freq_renter_point?
    @strategy.eligible_for_bonus_freq_renter_point?
  end
end

module RegularMovie
  def flat_fee
    2
  end

  def daily_fee
    1.5
  end

  def days_free
    2
  end

  def eligible_for_bonus_freq_renter_point?
    false
  end
end

module NewReleaseMovie
  def flat_fee
    0
  end

  def daily_fee
    3
  end

  def days_free
    0
  end

  def eligible_for_bonus_freq_renter_point?
    true
  end
end

module ChildrensMovie
  def flat_fee
    1.5
  end

  def daily_fee
    1.5
  end

  def days_free
    3
  end

  def eligible_for_bonus_freq_renter_point?
    false
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie = movie
    @days_rented = days_rented
  end

  def total_charge
    @movie.flat_fee + [0, (@days_rented - @movie.days_free) * @movie.daily_fee].max
  end

  def freq_renter_points
    if @days_rented > 1 && @movie.eligible_for_bonus_freq_renter_point?
      2
    else
      1
    end
  end
end


class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(arg)
    @rentals << arg
  end

  def statement
    "Rental Record for #{@name}\n"\
    "#{line_items_for_movie_charges}\n"\
    "Amount owed is #{total_charge}\n"\
    "You earned #{total_freq_renter_points} frequent renter points"
  end

  def total_freq_renter_points
    @rentals.sum { |rental| rental.freq_renter_points }
  end

  def total_charge
    @rentals.sum { |rental| rental.total_charge }
  end

  def line_items_for_movie_charges
    @rentals.map do |rental|
      "\t" + rental.movie.title + "\t" + rental.total_charge.to_s + "\n"
    end.join
  end
end