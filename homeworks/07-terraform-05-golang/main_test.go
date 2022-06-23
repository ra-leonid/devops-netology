package main

import (
	"fmt"
	"reflect"
	"testing"
)

func testMetersInFeet(t *testing.T) {
	result := MetersInFeet(38)
	if result != 1.258 {
		t.Error("Expected 1.5, got ", result)
	}
}

func testMinElemArray(t *testing.T) {
	var result int
	var x []int

	x = []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	result = MinElemArray(x)
	if result != 9 {
		t.Error("Expected 9, got ", result)
	}

	x = []int{48, 96, 86, 68, -27, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	result = MinElemArray(x)
	if result != -27 {
		t.Error("Expected -27, got ", result)
	}

	x = []int{48, 96, 86, 68, 87, 82, 63, 70, 0, 34, 83, 27, 19, 97, 9, 17}
	result = MinElemArray(x)
	if result != 0 {
		t.Error("Expected 0, got ", result)
	}

	// и т.д.
}

func testDivBy(t *testing.T) {
	result := DivBy(1, 10, 3)
	compare := []int{3, 6, 9}
	fmt.Println(reflect.DeepEqual(result, compare))
}
