#!/usr/bin/env cabal
{- cabal:
build-depends: base, flow, bytestring, stringsearch, utf8-string, directory, split
-}
{-# LANGUAGE OverloadedStrings #-}

import Text.Printf
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString as SB
import qualified Codec.Binary.UTF8.String as UTF8
import qualified Data.ByteString.Lazy.Search as S
import Flow
import System.Directory
import Control.Monad
import Data.List.Split
import Data.List

replace :: SB.ByteString -> B.ByteString -> B.ByteString -> B.ByteString
replace = S.replace

cchunk :: Int -> String -> String -> (String, String)
cchunk 0 i acc = (acc, i)
cchunk 1 ('\\' : c : is) acc = (acc, '\\' : c : is)
cchunk n ('\\' : c : is) acc = cchunk (n-2) is (c : '\\' : acc)
cchunk n (c : is) acc = cchunk (n-1) is (c : acc)
cchunk n [] acc = (acc, [])

ccchunk n s = let (c, r) = cchunk n s [] in (reverse c, r)

chunkList :: Int -> String -> [String]
chunkList n [] = []
chunkList n s = let (c, r) = ccchunk n s in c : chunkList n r

cString :: B.ByteString -> String
cString =
    replace "\\" "\\\\"
    .> replace "\t" "\\t"
    .> replace "\n" "\\n"
    .> replace "\"" "\\\""
    .> B.concatMap (\x -> B.pack $ if x < 32 || x > 126
                                   then concatMap UTF8.encodeChar $ ((printf "\\x%02x" x)::String)
                                   else [x])
    .> B.unpack
    .> UTF8.decode
    .> chunkList (80 - (8 + 2))
    .> map ("\"" ++)
    .> map (++ "\"")
    .> intercalate "\n\t\t"


genTest :: Int -> IO ()
genTest i = do
    json <- B.readFile $ printf "tests/%03d.json" i
    putStrLn $ "\t\t" ++ cString json ++ ","
    let expectedFile = printf "tests/%03d.expected" i
    expectedExists <- doesFileExist expectedFile
    if expectedExists then do
        expected <- B.readFile expectedFile
        putStrLn $ "\t\t" ++ cString expected
    else
        putStrLn "\t\tNULL"

main :: IO ()
main = do
    putStrLn "{\n\t{ // 0"
    forM_ [1..53] (\i -> do
        let ii = if i > 24 then i - 2 else i - 1
        if i == 24 then
            return ()
        else do
            if i == 1 then return () else putStrLn $ "\t}, { // " ++ show ii
            genTest i)
    putStrLn "\t}\n}"
