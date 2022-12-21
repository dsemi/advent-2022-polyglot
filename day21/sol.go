package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type MonkT uint8
const (
	Num MonkT = iota
	Math
)

type Monkey struct {
	t MonkT
	v complex128
	l, r string
	op func(complex128, complex128) complex128
}

func monkeys() map[string]Monkey {
	m := make(map[string]Monkey)
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		pts := strings.Fields(scanner.Text())
		if len(pts) == 2 {
			n, _ := strconv.Atoi(pts[1])
			m[pts[0][:len(pts[0])-1]] = Monkey{t: Num, v: complex(float64(n), 0)}
		} else {
			var op func(complex128, complex128) complex128
			if pts[2] == "+" {
				op = func(a, b complex128) complex128 { return a + b }
			} else if pts[2] == "-" {
				op = func(a, b complex128) complex128 { return a - b }
			} else if pts[2] == "*" {
				op = func(a, b complex128) complex128 { return a * b }
			} else if pts[2] == "/" {
				op = func(a, b complex128) complex128 { return a / b }
			}
			m[pts[0][:len(pts[0])-1]] = Monkey{t: Math, l: pts[1], op: op, r: pts[3]}
		}
	}
	return m
}

func eval(ms map[string]Monkey, k string, p2 bool) complex128 {
	if p2 && k == "humn" {
		return 0 + 1i
	}
	m := ms[k]
	switch m.t {
	case Num:
		return m.v
	case Math:
		return m.op(eval(ms, m.l, p2), eval(ms, m.r, p2))
	}
	panic("unreachable")
}

func main() {
	fmt.Println("Day 21: Go")
	ms := monkeys()
	fmt.Printf("Part 1: %20d\n", int(real(eval(ms, "root", false))))
	root := ms["root"]
	l := eval(ms, root.l, true)
	r := eval(ms, root.r, true)
	var p2 int
	if imag(l) != 0 {
		p2 = int((real(r) - real(l)) / imag(l))
	} else {
		p2 = int((real(l) - real(r)) / imag(r))
	}
	fmt.Printf("Part 2: %20d\n", p2)
}
