module Example2 where

--------------------------------------------------------------------------
-- imports

-- QuickCheck
import Test.QuickCheck.Gen
import Test.QuickCheck.Arbitrary
import Test.QuickCheck.Property
import Test.QuickCheck.Test
import Test.QuickCheck.Monadic

-- other
import Control.Monad.ST
import Data.STRef
import Data.Char

--------------------------------------------------------------------------
-- example

prop_WriteThenRead =
  monadicS runST (
    do ref <- run (newSTRef undefined)
       x <- pick (arbitrary :: Gen Int)
       run (writeSTRef ref x)
       y <- run (readSTRef ref)
       assert (x == y)
  )

newtype PrintableChar = Printable{ unPrintable :: Char }

instance Arbitrary PrintableChar where
  arbitrary = (Printable . chr) `fmap` choose (32,127)

instance MonadS ST where
  return' = return
  bind'   = (>>=)

{-
propIO_WriteFileThenRead =
  monadic $
    do s <- map unPrintable `fmap` pick (arbitrary :: Gen [PrintableChar])
       run (writeFile "apa" s)
       s' <- run (readFile "apa")
       assert (s == s')
-}

run args =
  do quickCheckWith args prop_WriteThenRead
     --quickCheckWith argsIO propIO_WriteFileThenRead

--------------------------------------------------------------------------
-- the end.
