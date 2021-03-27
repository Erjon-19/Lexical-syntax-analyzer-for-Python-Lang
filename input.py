import cmath

dict = { 

	"brand" : 'Ford',
	"model" : 'Mustang',
	"year" : 1964,
	"electric" : 'ok'
}

class Person:

    def __init__(self, name, age):
        self.name = name
        self.age = age

    def greet(msg):
        print(msg)

    # call of function
    greet('Good morning!')

    def num_check(self, num):

        self.num = num
        # Try these two variations as well:
        # num = 0
        # num = -4.5
        if num > 0:
            print("Positive number")
        elif num == 0:
            print("Zero")
        else:
            print("Negative number")

    def color(self):
        fruits = ["red", "green", "blue"]
        for x in fruits:
            print(x)

    def calculate(self):
        x = 2 * 4 + 3 - (10 + 5)
        return x


# object creation
p1 = Person("John", 36)

# call method
p1.num_check(num=-3)

print(p1.calculate())


