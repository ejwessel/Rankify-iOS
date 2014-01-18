<?php 
	class PhotosController extends AppController {
	    public $helpers = array('Html', 'Form', 'Session');
	    public $components = array('Session');
	    public $uses = array('Photo', 'PhotoLike');
	
	    public function index() {
	        $this->set('photos', $this->Photo->find('all'));
	    }

		public function getPhotos($userID){
			$this->autoRender = false;
			
#=================================
			$userID = '519651695';#israel'100003123648086';
			$accessToken = 'CAAT3J8mI45EBAGm7msdmgwRmiFkyMYAyZAnrR5W0aqfbFedtZAx4Lnxi92fgVzVqlh6xfqCxcOBFYmbecfO7eZCDyTZCVCsKjV01lBwADgv6UwwIZCnZARu63ZBQvctQU4ZAtQQ4Yp02KUBYtZCgebZCu1z2kkPxrMxnCA59CV9fexRxzBYRixBZAzoBRAjL7vMNjUZD';

#israel; 
#'CAACEdEose0cBANZBu0aZBpiQxZBXm3qkQl2pNRSyWSyG8OOa5v5qlZCxmtVIZBmJmKibZAOlyGRZAQViBEyl0qqCk8IdArxHq293SaAOq0nhAGiA1FpEBbZBeMin2DvHQY3DRTAJQrnXkIfN38izZALqaj4ZCBYrNE7GZCpW6y02n1CyIZBQXsMSz5FZC3jpvc7Fdy6kZD';
#=================================
					
			#send the query for photos					
			$photos = object_to_array(json_decode(file_get_contents('https://graph.facebook.com/'.$userID.'/?fields=photos.type(uploaded).fields(id,source,name,likes.limit(5))&access_token='.$accessToken)));
			#ields=photos.type(uploaded).fields(id)
			if(isset($photos['paging']['next'])){
				$nextUrl = $photos['photos']['paging']['next'];
			}
			$photos = $photos['photos']['data'];
			#while paging has next url
			#if next data is empty end
			while(!empty($photos)) {
				#if there are photos to save
				foreach($photos AS $photo){
					#go through the photos				
					$checkPhoto = $this->Photo->find('first', array('conditions'=> array('Photo.photoId' => $photo['id'])));
					if(empty($checkPhoto)){
						#if there are photos that are not added, then save them
						$this->Photo->create();
						$this->Photo->saveField('userId', $userID);
						$this->Photo->saveField('photoId', $photo['id']);
				        $this->Photo->saveField('source', $photo['source']);
				        if(isset($photo['name'])){
					        $this->Photo->saveField('name', $photo['name']);
				        }
				        
				        if(isset($photo['likes']['data'])) {
							#if a like exists we're going to begin counting them
					        $this->likes($photo['id'], $userID, $photo['likes']); #photo id, user id
				        }
					}
					else {
				        if(isset($photo['likes']['data'])) {
							#if a like exists we're going to begin counting them
					        $this->likes($photo['id'], $userID, $photo['likes']); #photo id, user id
				        }
					}
				}
				
				#if there is another page of data
				if(!empty($nextUrl)) {
					#if there is a next URL
					$photos = object_to_array(json_decode(file_get_contents($nextUrl)));
					if(isset($photos['paging']['next'])){
						#if there is a field for next, set it
						$nextUrl = $photos['paging']['next'];
					}
					else {
						#else if there isn't, clear it
						$nextUrl = array();
					}
					#obtain the photos, for next iteration
					$photos = $photos['data'];	
				} 
				else {
					#if there arent any next photos, nothing new, so clear
					$photos = array();
				}
			}

		}
		
	    public function view($id) {
	        if (!$id) {
	            throw new NotFoundException(__('Invalid post'));
	        }
	
	        $user = $this->Photo->findById($id);
	        if (!$user) {
	            throw new NotFoundException(__('Invalid post'));
	        }
	        $this->set('user', $user);
	    }
	
	    public function add() {
	        if ($this->request->is('post')) {
	            $this->Photo->create();
	            if ($this->Photo->save($this->request->data)) {
	                $this->Session->setFlash(__('Your post has been saved.'));
	                return $this->redirect(array('action' => 'index'));
	            }
	            $this->Session->setFlash(__('Unable to add your post.'));
	        }
	    }
	    
	    private function likes($photoID, $userID, $likes){
	    	
	    	
	    	if(isset($likes['paging']['next'])){
				$nextUrl = $likes['paging']['next'];
			}
			$likes = $likes['data'];
	    
			while(!empty($likes)) {	    	
		    	foreach($likes AS $like) {
			    	$checkLike = $this->PhotoLike->find('first', array('conditions'=> array('PhotoLike.photoId' => $photoID, 'PhotoLike.userId' => $userID, 'PhotoLike.friendId' => $like['id'])));
			    	
			    	if(empty($checkLike)) {
				    	$this->PhotoLike->create();
						$this->PhotoLike->saveField('photoId', $photoID);
						$this->PhotoLike->saveField('userId', $userID);
						$this->PhotoLike->saveField('friendId', $like['id']);	
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