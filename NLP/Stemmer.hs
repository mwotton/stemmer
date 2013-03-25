
-- | Haskell bindings for the Snowball stemming library
-- A 'pure' stemming interface. Strings should use UTF-8 encoding. 
module NLP.Stemmer ( 
    -- * Stemming algorithms
      Algorithm(..)
    -- * Stemming functions
    , stem
    , stemWords
    ) where

import           NLP.Stemmer.C (Algorithm)
import qualified NLP.Stemmer.C as C
import           System.IO.Unsafe (unsafePerformIO)

-- | Stem a word
stem :: Algorithm -> String -> String
stem algorithm input = withStemmer algorithm (`C.stem` input)

-- | Stem a list of words, more efficient than @map 'stem'@
stemWords :: Algorithm -> [String] -> [String]
stemWords algorithm input = withStemmer algorithm (\stemmer -> mapM (C.stem stemmer) input)

{-# NOINLINE withStemmer #-}
withStemmer :: Algorithm -> (C.Stemmer -> IO a) -> a
withStemmer algorithm action = unsafePerformIO $ C.withStemmer algorithm action
