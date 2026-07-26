import { UINT32 } from '../src/cuint.js'
import { assert, assertEquals, assertThrows } from 'https://deno.land/std/testing/asserts.ts'

// Verifies construction, conversion, arithmetic, comparison, and cloning.
Deno.test('UINT32_arithmetic_Test', () => {
    assertEquals(UINT32(1).toNumber(), 1)
    assertEquals(new UINT32(0xffff, 1).toNumber(), 131071)
    assertEquals(new UINT32('ff', 16).toString(16), 'ff')
    assertEquals(new UINT32('10').toString(), '10')
    assertEquals(UINT32(2).add(UINT32(3)).toNumber(), 5)
    assertEquals(UINT32(5).subtract(UINT32(3)).toNumber(), 2)
    assertEquals(UINT32(7).multiply(UINT32(6)).toNumber(), 42)
    assert(UINT32(5).eq(UINT32(5)))
    assert(UINT32(0x10000).gt(UINT32(1)))
    assert(UINT32(1).lt(UINT32(0x10000)))
    assertEquals(UINT32(9).clone().toNumber(), 9)
})

// Verifies division special cases and the long-division path.
Deno.test('UINT32_division_Test', () => {
    assertThrows(() => UINT32(1).div(UINT32(0)), Error, 'division by zero')
    assertEquals(UINT32(7).div(UINT32(1)).toNumber(), 7)
    assertEquals(UINT32(1).div(UINT32(2)).toNumber(), 0)
    assertEquals(UINT32(7).div(UINT32(7)).toNumber(), 1)
    const quotient = UINT32(0x30000).div(UINT32(3))
    assertEquals(quotient.toNumber(), 0x10000)
    assertEquals(quotient.remainder.toNumber(), 0)
    const remainder = UINT32(17).div(UINT32(5))
    assertEquals(remainder.toNumber(), 3)
    assertEquals(remainder.remainder.toNumber(), 2)
})

// Verifies bitwise, shift, rotate, and negate operations.
Deno.test('UINT32_bitwise_Test', () => {
    assertEquals(UINT32(0x0f).or(UINT32(0xf0)).toNumber(), 0xff)
    assertEquals(UINT32(0xff).and(UINT32(0x0f)).toNumber(), 0x0f)
    assertEquals(UINT32(0x0f).xor(UINT32(0xff)).toNumber(), 0xf0)
    assertEquals(UINT32(0).not().toNumber(), 0xffffffff)
    assertEquals(UINT32(1).negate().toNumber(), 0xffffffff)
    assertEquals(UINT32(0x10001).shiftRight(1).toNumber(), 0x8000)
    assertEquals(UINT32(0x10001).shiftRight(16).toNumber(), 1)
    assertEquals(UINT32(0x10000).shiftRight(17).toNumber(), 0)
    assertEquals(UINT32(1).shiftLeft(1).toNumber(), 2)
    assertEquals(UINT32(1).shiftLeft(16).toNumber(), 0x10000)
    assertEquals(UINT32(1).shiftLeft(17).toNumber(), 0x20000)
    assertEquals(UINT32(0xffffffff).shiftLeft(17, true)._high, 0x1fffe)
    assertEquals(UINT32(0x80000001).rotateLeft(1).toNumber(), 3)
    assertEquals(UINT32(3).rotateRight(1).toNumber(), 0x80000001)
})

// Verifies high-word comparison branches.
Deno.test('UINT32_comparison_Test', () => {
    assert(UINT32(0x20000).gt(UINT32(0x10000)))
    assert(!UINT32(0x10000).gt(UINT32(0x20000)))
    assert(UINT32(0x10000).lt(UINT32(0x20000)))
    assert(!UINT32(0x20000).lt(UINT32(0x10000)))
})
