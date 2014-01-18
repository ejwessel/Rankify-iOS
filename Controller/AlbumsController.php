<?php 
	class AlbumsController extends AppController {
	    public $helpers = array('Html', 'Form', 'Session');
	    public $components = array('Session');
	    public $uses = array('Album', 'AlbumLike');
	
	    public function index() {
	        $this->set('album', $this->Album->find('all'));
	    }

		public function getAlbums($userID){
			$this->autoRender = false;
			
#=================================
			$userID = '519651695';#'100003123648086';#israel'519651695';
			$accessToken = 'CAAT3J8mI45EBACo4sIZAnErVqxVToTsbJrLqIGU9Ed8muJnNORqlZBDI7bl78V3o33ZALvsLDBjAYskDUaR9a4RKQQFrmTd9M7EPe2b3jaA3tbUifS2VINkAUJS3kKIKWxsZCCTdeZCchst4XoDuYrtvZASxAAAyzMLJ5sDPZB3xMyimwxo30Txergm0fYJFmcZD';

#=================================
					
			#send the query for photos					
			$albums = object_to_array(json_decode(file_get_contents('https://graph.facebook.com/'.$userID.'/?fields=albums.limit(1).fields(id,name,link,likes)&access_token='.$accessToken)));

			if(isset($albums['albums']['paging']['next'])){
				$nextUrl = $albums['albums']['paging']['next'];
			}
			
			$albums = $albums['albums']['data'];
			#while paging has next url
			#if next data is empty end
			while(!empty($albums)) {
				#if there are photos to save
				foreach($albums AS $album){
					#go through the photos				
					$checkAlbum = $this->Album->find('first', array('conditions'=> array('Album.albumId' => $album['id'])));
					
					if(empty($checkAlbum)){
						#if there are photos that are not added, then save them
						$this->Album->create();
						$this->Album->saveField('userId', $userID);
						$this->Album->saveField('albumId', $album['id']);
				        $this->Album->saveField('link', $album['link']);
				        if(isset($album['name'])){
					        $this->Album->saveField('name', $album['name']);
				        }
				        
				        if(isset($album['likes']['data'])) {
							#if a like exists we're going to begin counting them
					        $this->likes($album['id'], $userID, $album['likes']); #photo id, user id
				        }
					}
					else {
				        if(isset($album['likes']['data'])) {
							#if a like exists we're going to begin counting them
					        $this->likes($album['id'], $userID, $album['likes']); #photo id, user id
				        }
					}
				}
								
				#if there is another page of data
				if(!empty($nextUrl)) {
					#if there is a next URL
					$albums = object_to_array(json_decode(file_get_contents($nextUrl)));
					
					if(isset($albums['paging']['next'])){
						#if there is a field for next, set it
						$nextUrl = $albums['paging']['next'];
					}
					else {
						#else if there isn't, clear it
						$nextUrl = array();
					}
					#obtain the photos, for next iteration
					$albums = $albums['data'];	
				} 
				else {
					#if there arent any next photos, nothing new, so clear
					$albums = array();
				}
			}

		}
	    
	    private function likes($albumID, $userID, $likes){
	    	
	    	
	    	if(isset($likes['paging']['next'])){
				$nextUrl = $likes['paging']['next'];
			}
			$likes = $likes['data'];
	    
			while(!empty($likes)) {	    	
		    	foreach($likes AS $like) {
			    	$checkLike = $this->AlbumLike->find('first', array('conditions'=> array('AlbumLike.albumId' => $albumID, 'AlbumLike.userId' => $userID, 'AlbumLike.friendId' => $like['id'])));
			    	
			    	if(empty($checkLike)) {
				    	$this->AlbumLike->create();
						$this->AlbumLike->saveField('albumId', $albumID);
						$this->AlbumLike->saveField('userId', $userID);
						$this->AlbumLike->saveField('friendId', $like['id']);	
			    	}
		    	}
		    	
		    	#if there is another page of data
				if(!empty($nextUrl)) {
					#if there is a next URL
					$likes = object_to_array(json_decode(file_get_contents($nextUrl)));
					if(isset($likes['paging']['next'])){
						#if there is a field for next, set it
						$nextUrl = $likes['paging']['next'];
					}
					else {
						#else if there isn't, clear it
						$nextUrl = array();
					}
					#obtain the photos, for next iteration
					$likes = $likes['data'];	
				} 
				else {
					#if there arent any next photos, nothing new, so clear
					$likes = array();
				}
		    }
		}
	}
	
	function object_to_array($data) {
	    if (is_array($data) || is_object($data))
	    {
	        $result = array();
	        foreach ($data as $key => $value)
	        {
	            $result[$key] = object_to_array($value);
	        }
	        return $result;
	    }
	    return $data;
	}
?>