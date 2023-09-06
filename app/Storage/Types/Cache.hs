module Storage.Types.Cache where

import Control.Concurrent (ThreadId, forkIO)
import qualified Control.Concurrent.Chan.Unagi.Bounded as Chan
import Control.Monad (forever)
import Data.HashMap.Strict (HashMap)
import Data.IORef (IORef, newIORef)
import Data.Text
import Storage.Types.Album
import Storage.Types.Artist

-- import Storage.Types.Customer
-- import Storage.Types.Employee
-- import Storage.Types.Genre
-- import Storage.Types.Invoice
-- import Storage.Types.InvoiceLine
-- import Storage.Types.MediaType
-- import Storage.Types.Playlist
-- import Storage.Types.PlaylistTrack
-- import Storage.Types.Track

data CacheValue a = PrimaryIdx Text | PrimaryIdxs [Text] | ForeignIdx ([Text], a) deriving (Show)

type CacheMap a = HashMap Text (CacheValue a)

data CacheQueueValueData a = CacheQueueValueData
  { _primaryKey :: Text,
    _secondaryKeys :: [Text],
    _foriegnKeys :: Text,
    _cacheValue :: CacheValue a
  }

data Cache = Cache
  { _albumCache :: IORef (CacheMap Album),
    _artistCache :: IORef (CacheMap Artist)
  }

getDefaultCache :: IO Cache
getDefaultCache = do
  album <- newIORef mempty
  artist <- newIORef mempty
  return $
    Cache
      { _albumCache = album,
        _artistCache = artist
      }
