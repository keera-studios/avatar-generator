module ImageManipulation where

-- To manipulate images using JuicyPixel
import Data.Word
import Codec.Picture

type Img a = Int -> Int -> a

emptyRGBA8 :: PixelRGBA8
emptyRGBA8 = PixelRGBA8 0 0 0 0

imageFilter :: (a -> b) -> Img a -> Img b
imageFilter filter img = \x y -> filter (img x y)

crop :: Int -> Int -> a -> Img a -> Img a
crop w h d f = \x y -> if x >= w || y >= h then d else f x y

scale :: Int -> Int -> Int -> Int -> Img a -> a -> Img a
scale dw dh w h img bg = move (marginLeft, marginTop) (zoom zhf zvf img) bg
  where marginLeft = (dw - (zhf * w)) `div` 2
        marginTop  = (dh - (zvf * h)) `div` 2
        zhf        = dw `div` w
        zvf        = dh `div` h

move :: (Int, Int) -> Img a -> a -> Img a
move (dx,dy) img bg x y
  | x < dx || y < dy = bg
  | otherwise        =  img (x - dx) (y - dy)

zoom :: Int -> Int -> Img a -> Img a
zoom zh zv f = \x y -> f (x `div` zh) (y `div` zv)

hflip :: Int -> Img a -> Img a
hflip w f   = \x y -> f (w - 1 - x) y

hNext :: Int -> Img a -> Img a -> Img a
hNext w f g = \x y -> if x < w then f x y else g (x - w) y

hMirror :: Int -> Img a -> Img a
hMirror w orig = hNext (midColumn w) orig flipped
  where flipped     = hflip (halfWidth w) orig
        midColumn w = if odd w then (w `div` 2) + 1 else (w `div` 2)
        halfWidth w = w `div` 2
