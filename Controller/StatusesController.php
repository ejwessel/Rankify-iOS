<?php 
	class StatusesController extends AppController {
	    public $helpers = array('Html', 'Form', 'Session');
	    public $components = array('Session');
	    public $uses = array('Status', 'StatusLike');
	
	    public function index() {
	        $this->set('status', $this->Status->find('all'));
	    }

		public function getStatuses($userID){
			$this->autoRender = false;
			
#=================================
			$userID = '519651695';#'100003123648086';#israel'519651695';
			$accessToken = 'CAAT3J8mI45EBAGrwY39VeODFhXeNjNotZAg26EfXBaH6m78kLw9jrLjH3XBTBFBAji2uoXZCpSGqbiuoYbZCy1lFtEvxGbVHnEQOIjOiKCnRP0DmgBWe6wrZBngM40rdFpe6LXY0TxYtz4nD1FJ0TZAT3AFeqbR0yH6ctZBeyaDTZCAAkMpTvFkwZBd42Ix82MwZD';

#=================================
					
			#send the query for photos					
			$statuses = object_to_array(json_decode(file_get_contents('https://graph.facebook.com/'.$userID.'/?fields=statuses.fields(likes,message,id)&access_token='.$accessToken)));

			if(isset($statuses['statuses']['paging']['next'])){
				$nextUrl = $statuses['statuses']['paging']['next'];
			}
			
			$statuses = $statuses['statuses']['data'];
			#while paging has next url
			#if next data is empty end
			while(!empty($statuses)) {
				#if there are photos to save
				foreach($statuses AS $status){
					#go through the photos				
					$checkStatus = $this->Status->find('first', array('conditions'=> array('Status.statusId' => $status['id'])));
					
					if(empty($checkStatus)){
						#if there are photos that are not added, then save them
						$this->Status->create();
						$this->Status->saveField('userId', $userID);
						$this->Status->saveField('statusId', $status['id']);
				        if(isset($status['message'])){
					        $this->Status->saveField('message', $status['message']);
				        }
				        
				        if(isset($status['likes']['data'])) {
							#if a like exists we're going to begin counting them
					        $this->likes($status['id'], $userID, $status['likes']); #photo id, user id
				        }
					}
					else {
				        if(isset($status['likes']['data'])) {
							#if a like exists we're going to begin counting them
					        $this->likes($status['id'], $userID, $status['likes']); #photo id, user id
				        }
					}
				}
								
				#if there is another page of data
				if(!empty($nextUrl)) {
					#if there is a next URL
					$statuses = object_to_array(json_decode(file_get_contents($nextUrl)));
					
					if(isset($statuses['paging']['next'])){
						#if there is a field for next, set it
						$nextUrl = $statuses['paging']['next'];
					}
					else {
						#else if there isn't, clear it
						$nextUrl = array();
					}
					#obtain the photos, for next iteration
					$statuses = $statuses['data'];	
				} 
				else {
					#if there arent any next photos, nothing new, so clear
					$statuses = array();
				}
			}

		}
	    
	    private function likes($statusID, $userID, $likes){
	    	
	    	
	    	if(isset($likes['paging']['next'])){
				$nextUrl = $likes['paging']['next'];
			}
			$likes = $likes['data'];
	    
			while(!empty($likes)) {	    	
		    	foreach($likes AS $like) {
			    	$checkLike = $this->StatusLike->find('first', array('conditions'=> array('StatusLike.statusId' => $statusID, 'StatusLike.userId' => $userID, 'StatusLike.friendId' => $like['id'])));
			    	
			    	if(empty($checkLike)) {
				    	$this->StatusLike->create();
						$this->StatusLike->saveField('statusId', $statusID);
						$this->StatusLike->saveField('userId', $userID);
						$this->StatusLike->saveField('friendId', $like['id']);	
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