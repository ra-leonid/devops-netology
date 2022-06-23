package main

import (
	"fmt"
	"log"
)

func main() {
	// Перевод метров в футы
	fmt.Print("Enter how many meters: ")
	var input float64
	fmt.Scanf("%f", &input)
	output := MetersInFeet(input)

	fmt.Println(fmt.Sprintf("%.2f", output), "feet")

	// Минимальное значение в массиве
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}

	min_elem := MinElemArray(x)

	fmt.Println(fmt.Sprintf("The minimum element of the array is %d", min_elem))

	// Числа от 1 до 100 делящиеся на 3 без отстатка
	div_by_3 := DivBy(1, 101, 3)

	fmt.Println("Numbers divisible by 3:")
	for _, elem := range div_by_3 {
		fmt.Println(elem)
	}
}

func MetersInFeet(meters float64) float64 {
	return meters * 0.3048
}

func MinElemArray(array []int) int {

	if len(array) == 0 {
		log.Fatal("Array is empty")
	}

	min_elem := array[0]

	for _, elem := range array {
		if min_elem > elem {
			min_elem = elem
		}
	}

	return min_elem
}

func DivBy(start int, stop int, div_by int) []int {

	if start > stop {
		log.Fatal("The initial value must be less than the final one")
	}

	if div_by == 0 {
		log.Fatal("The divisor must be non-zero")
	}

	if div_by > stop || div_by < start {
		log.Fatal("Value outside the range")
	}

	result := make([]int, 0, stop-start)
	for i := start; i < stop; i++ {
		if (i % div_by) == 0 {
			result = append(result, i)
		}
	}

	return result
}
