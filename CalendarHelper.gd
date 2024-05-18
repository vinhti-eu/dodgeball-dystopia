extends Node2D

onready var curr_day = 1
onready var curr_month = 1
var curr_year = 2046

enum Months {
	JANUARY = 1,
	FEBRUARY = 2,
	MARCH = 3,
	APRIL = 4,
	MAY = 5,
	JUNE = 6,
	JULY = 7,
	AUGUST = 8,
	SEPTEMBER = 9,
	OCTOBER = 10,
	NOVEMBER = 11,
	DECEMBER = 12
}
enum Weekdays {
	MONDAY = 1,
	TUESDAY = 2,
	WEDNESDAY = 3,
	THURSDAY = 4,
	FRIDAY = 5,
	SATURDAY = 6,
	SUNDAY = 7
}


func get_num_of_days(month, year = 0):
	if month == Months.JANUARY:
		return 31
	elif month == Months.FEBRUARY:
		if year != 0 and is_leap_year(year):
			return 29
		else:
			return 28
	elif month == Months.MARCH:
		return 31
	elif month == Months.APRIL:
		return 30
	elif month == Months.MAY:
		return 31
	elif month == Months.JUNE:
		return 30
	elif month == Months.JULY:
		return 31
	elif month == Months.AUGUST:
		return 31
	elif month == Months.SEPTEMBER:
		return 30
	elif month == Months.OCTOBER:
		return 31
	elif month == Months.NOVEMBER:
		return 30
	elif month == Months.DECEMBER:
		return 31
	else:
		return 0  # Invalid month

func is_leap_year(year):
	if year % 4 == 0:
		if year % 100 == 0:
			if year % 400 == 0:
				return true
			else:
				return false
		else:
			return true
	else:
		return false

func next_day():
	curr_day += 1
	if curr_day > get_num_of_days(curr_month, curr_year):
		curr_day = 1
		curr_month += 1
		if curr_month > 12:
			curr_month = 1
			curr_year += 1

func get_day_of_year(day, month):
	var calc_month = Months.JANUARY
	var day_result = 0
	while calc_month < month:
		day_result += get_num_of_days(calc_month, curr_year)
		calc_month += 1
	day_result += day
	return day_result

func get_curr_weekday():
	var day = get_weekday(curr_day,curr_month,curr_year)
	return day

func get_weekday(day, month, year):
	var day_of_year = get_day_of_year(day, month)
	var year_days = 0
	if year >= 2046:
		for y in range(2046, year):
			year_days += 366 if is_leap_year(y) else 365
	else:
		for y in range(year, 2046):
			year_days -= 366 if is_leap_year(y) else 365

	var total_days = year_days + day_of_year - 1
	var weekday = (total_days % 7 + Weekdays.MONDAY - 1) % 7 + 1
	return weekday

# Called when the node enters the scene tree for the first time.
func _ready():
	curr_month = Months.JANUARY
	curr_day = 1

	next_day()
	next_day()
	next_day()
	next_day()
	next_day()
	next_day()
	next_day()
	next_day()
	print(curr_day, ':', curr_month, ':', curr_year, ':',get_weekday(curr_day,curr_month,curr_year))
