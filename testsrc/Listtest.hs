{- arch-tag: List tests main file
Copyright (C) 2004 John Goerzen <jgoerzen@complete.org>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-}

module Listtest(tests) where
import HUnit
import MissingH.List

test_delFromAL = 
    let f :: [(String, Int)] -> [(String, Int)] -> Assertion
        f inp exp = exp @=? (delFromAL inp "testkey") in
        do
                 f [] []
                 f [("one", 1)] [("one", 1)]
                 f [("1", 1), ("2", 2), ("testkey", 3)] [("1", 1), ("2", 2)]
                 f [("testkey", 1)] []
                 f [("testkey", 1), ("testkey", 2)] []
                 f [("testkey", 1), ("2", 2), ("3", 3)] [("2", 2), ("3", 3)]
                 f [("testkey", 1), ("2", 2), ("testkey", 3), ("4", 4)]
                   [("2", 2), ("4", 4)]

test_addToAL =
    let f :: [(String, Int)] -> [(String, Int)] -> Assertion
        f inp exp = exp @=? (addToAL inp "testkey" 101) in
        do
        f [] [("testkey", 101)]
        f [("testkey", 5)] [("testkey", 101)]
        f [("testkey", 5), ("testkey", 6)] [("testkey", 101)]

test_split =
    let f delim inp exp = exp @=? split delim inp in
        do
        f "," "foo,bar,,baz," ["foo", "bar", "", "baz", ""]
        f "ba" ",foo,bar,,baz," [",foo,","r,,","z,"]
        f "," "" []
        f "," "," ["", ""]

test_join =
    let f :: (Eq a, Show a) => [a] -> [[a]] -> [a] -> Assertion
        f delim inp exp = exp @=? join delim inp in
        do
        f "|" ["foo", "bar", "baz"] "foo|bar|baz"
        f "|" [] ""
        f "|" ["foo"] "foo"
        -- f 5 [[1, 2], [3, 4]] [1, 2, 5, 3, 4]

test_genericJoin =
    let f delim inp exp = exp @=? genericJoin delim inp in
        do
        f ", " [1, 2, 3, 4] "1, 2, 3, 4"
        f ", " ([] :: [Int]) ""
        f "|" ["foo", "bar", "baz"] "\"foo\"|\"bar\"|\"baz\""
        f ", " [5] "5"

test_flipAL =
    let f inp exp = exp @=? flipAL inp in
        do
        f ([]::[(Int,Int)]) ([]::[(Int,[Int])])
        f [("a", "b")] [("b", ["a"])]
        f [("a", "b"),
           ("c", "b"),
           ("d", "e"),
           ("b", "b")] [("b", ["b", "c", "a"]),
                        ("e", ["d"])]

test_trunc =
    let f len inp exp = exp @=? trunc len inp in
        do
        f 2 "Hello" "He"
        f 1 "Hello" "H"
        f 0 "Hello" ""
        f 2 "H" "H"
        f 2 "" ""
        f 2 [1, 2, 3, 4, 5] [1, 2]
        f 10 "Hello" "Hello"
        f 0 "" ""
                      

test_contains =
    let f msg sub testlist exp = assertEqual msg exp (contains sub testlist) in
        do
        f "t1" "Haskell" "I really like Haskell." True
        f "t2" "" "Foo" True
        f "t3" "" "" True
        f "t4" "Hello" "" False
        f "t5" "Haskell" "Haskell" True
        f "t6" "Haskell" "1Haskell" True
        f "t7" "Haskell" "Haskell1" True
        f "t8" "Haskell" "Ocaml" False
        f "t9" "Haskell" "OCamlasfasfasdfasfd" False
        f "t10" "a" "Hello" False
        f "t11" "e" "Hello" True

test_elemRIndex =
    let f item inp exp = exp @=? elemRIndex item inp in
        do
        f "foo" [] Nothing
        f "foo" ["bar", "baz"] Nothing
        f "foo" ["foo"] (Just 0)
        f "foo" ["foo", "bar"] (Just 0)
        f "foo" ["bar", "foo"] (Just 1)
        f "foo" ["foo", "bar", "foo", "bar", "foo"] (Just 4)
        f 'f' ['f', 'b', 'f', 'f', 'b'] (Just 3)
        f 'f' ['b', 'b', 'f'] (Just 2)

test_alwaysElemRIndex =
    let f item inp exp = exp @=? alwaysElemRIndex item inp in
        do
        f "foo" [] (-1)
        f 'f' ['b', 'q'] (-1)
        f 'f' ['f', 'b', 'f', 'f', 'b'] 3

tests = TestList [TestLabel "delFromAL" (TestCase test_delFromAL),
                  TestLabel "addToAL" (TestCase test_addToAL),
                  TestLabel "split" (TestCase test_split),
                  TestLabel "join" (TestCase test_join),
                  TestLabel "genericJoin" (TestCase test_genericJoin),
                  TestLabel "trunc" (TestCase test_trunc),
                  TestLabel "flipAL" (TestCase test_flipAL),
                  TestLabel "elemRIndex" (TestCase test_elemRIndex),
                  TestLabel "alwaysElemRIndex" (TestCase test_alwaysElemRIndex),
                  TestLabel "contains" (TestCase test_contains)]


