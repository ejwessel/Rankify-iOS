<?php 
	class VideosController extends AppController {
	    public $helpers = array('Html', 'Form', 'Session');
	    public $components = array('Session');
	    public $uses = array('Video', 'VideoLike');
	
	    public function index() {
	        $this->set('video', $this->Video->find('all'));
	    }

		public function getVideos($userID){
			$this->autoRender = false;
			
#=================================
			$userID = '519651695';#'100003123648086';#israel'519651695';
			$accessToken = 'CAAT3J8mI45EBAPVmb9YGTkvU87QiX30FwO67sZAPcav9IJM3XiPUEZCDk3dzODOItUKixsX2OtrO9smKA9JVOUuPV5iPGKERPJnHEYORFLpZBjtAbfosITcNyPQZAhFEZAKTjG5iAppjhzU0Q5SIYdetDOIazZAx3EBLCB1V264NaPbh5NByAlpZAZASK5BO1igZD';

#=================================
					
			#send the query for photos					
			$videos = object_to_array(json_decode(file_get_contents('https://graph.facebook.com/'.$userID.'/?fields=videos.limit(10).type(uploaded).fields(id,name,description,likes)&access_token='.$accessToken)));

			if(isset($videos['videos']['paging']['next'])){
				$nextUrl = $videos['videos']['paging']['next'];
			}
			
			$videos = $videos['videos']['data'];
			#while paging has next url
			#if next data is empty end
			while(!empty($videos)) {
				#if there are photos to save
				foreach($videos AS $video){
					#go through the photos				
					$checkVideo = $this->Video->find('first', array('conditions'=> array('Video.videoId' => $video['id'])));
					
					if(empty($checkVideo)){
						#if there are photos that are not added, then save them
						$this->Video->create();
						$this->Video->saveField('userId', $userID);
						$this->Video->saveField('videoId', $video['id']);
						if(isset($video['name'])){
							$this->Video->saveField('name', $video['name']);
						}						
				        if(isset($video['description'])){
					        $this->Video->saveField('description', $video['description']);
				        }
				        
				        if(isset($video['likes']['data'])) {
							#if a like exists we're going to begin counting them
					        $this->likes($video['id'], $userID, $video['likes']); #photo id, user id
				        }
					}
					else {
				        if(isset($video['likes']['data'])) {
							#if a like exists we're going to begin counting them
					        $this->likes($video['id'], $userID, $video['likes']); #photo id, user id
				        }
					}
				}
								
				#if there is another page of data
				if(!empty($nextUrl)) {
					#if there is a next URL
					$videos = object_to_array(json_decode(file_get_contents($nextUrl)));
					
					if(isset($videos['paging']['next'])){
						#if there is a field for next, set it
						$nextUrl = $videos['paging']['next'];
					}
					else {
						#else if there isn't, clear it
						$nextUrl = array();
					}
					#obtain the photos, for next iteration
					$videos = $videos['data'];	
				} 
				else {
					#if there arent any next photos, nothing new, so clear
					$videos = array();
				}
			}

		}
	    
	    private function likes($videoID, $userID, $likes){
	    	
	    	
	    	if(isset($likes['paging']['next'])){
				$nextUrl = $likes['paging']['next'];
			}
			$likes = $likes['data'];
	    
			while(!empty($likes)) {	    	
		    	foreach($likes AS $like) {
			    	$checkLike = $this->VideoLike->find('first', array('conditions'=> array('VideoLike.videoId' => $videoID, 'VideoLike.userId' => $userID, 'VideoLike.friendId' => $like['id'])));
			    	
			    	if(empty($checkLike)) {
				    	$this->VideoLike->create();
						$this->VideoLike->saveField('videoId', $videoID);
						$this->VideoLike->saveField('userId', $userID);
						$this->VideoLike->saveField('friendId', $like['id']);	
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