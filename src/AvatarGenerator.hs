module AvatarGenerator where

-- JuicyPixel
import Data.Word
import Codec.Picture

-- To transform images
import ImageManipulation

avatarGenerator :: [Bool] -> (Word8, Word8, Word8) -> String -> IO ()
avatarGenerator vals (r,g,b) path = writePng path $
         generateImage bigImage desiredWidth desiredHeight

   where bigImage :: Img PixelRGBA8
         bigImage = scale desiredWidth desiredHeight width height smallImage emptyRGBA8

         smallImage :: Img PixelRGBA8
         smallImage = imageFilter color $ crop width height False avatar
           where color True  = PixelRGBA8 r g b 255
                 color False = emptyRGBA8

         avatar :: Img Bool
         avatar = hMirror width lhsAvatar
           where lhsAvatar x y = vals !! ((y * width) + x) 

         width  = 5
         height = 5

         desiredWidth  = 512
         desiredHeight = 512
