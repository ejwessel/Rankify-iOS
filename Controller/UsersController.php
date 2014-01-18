<?php 
	class UsersController extends AppController {
	    public $helpers = array('Html', 'Form', 'Session');
	    public $components = array('Session');
		public $uses = array('User', 'UserFriend');
		
	    public function index() {
	        $this->set('users', $this->User->find('all'));
	       
	    }

		public function newUser($userID, $accessToken){
			$this->autoRender = false;

#=================================
			$userID = '519651695';#israel'100003123648086';
			$accessToken = '';
			#israel'CAAT3J8mI45EBAB8jIE1Huvy4mQVpGkbUeCkbjVrNyZCPWg6U1sufXw8oSwZA2687ZBnF6UNFHItEyjGYH48qCScyVcrEJqoQC7fCddIY965dmHmEHzsUGL11DTvu6xEiZB4pLzRnXYdTuCKlHFA5v476gisZAZBUP4es8hFufJZAj56qnRZCFZBio7PyiLPtJmCz804JM7Sxd1wZDZD';
#=================================
			
			$checkUser = $this->User->find('first',
									 array('conditions' => array('User.userId' => $userID)));
			if(empty($checkUser)){
				#user doesn't exit, make a new user
				$user = object_to_array(json_decode(file_get_contents('https://graph.facebook.com/'.$userID.'?fields=id,first_name,last_name,gender,username&access_token='.$accessToken)));

				$this->User->create();
				$this->User->saveField('userId', $user['id']);
				$this->User->saveField('userName', $user['username']);
			    $this->User->saveField('firstName', $user['first_name']);
			    $this->User->saveField('lastName', $user['last_name']);
			    $this->User->saveField('gender', $user['gender']);
			    $this->User->saveField('isUser', 1);

			}
			else{
				#if the user exists, then we are going to mark that they've logged into the app
				#this is necessary if Users have been added but they were not added through the application
				$this->User->id = $checkUser['User']['id'];
				$this->User->saveField('isUser',1);
				$this->User->saveField('accessToken', $accessToken);
			}
		}

		public function newFriends($userID){
			$this->autoRender = false;
			#assume we already have the access token
	        
			$user = $this->User->find('first',
									 array('conditions' => array('User.userId' => $userID)));
			if(!empty($user)){
				$accessToken = 'CAAT3J8mI45EBAEugHpiEji6pbnWb6AN08lCdYgfO43Uy4KalyVF3BZBJi8BIMMUGWqpmsDa4XX8CPHgnEWY0bNGeWpRHDzfpHd2LIDpaCZAoxaZAZApCJdZBXsGmOpaHUex3HRZCd57pfuP70IU9Giyp8ZA7KqePGkjgWikZBUNn9u23LblZCpRts7IUa9EC100IZD';
				$friends = object_to_array(json_decode(file_get_contents('https://graph.facebook.com/'.$userID.'?fields=friends.fields(id,first_name,last_name,username,gender)&access_token='.$accessToken)));
				
				pr($friends);
				exit;
				
				if(!empty($friends)){
					$friends = $friends['friends']['data'];
	        	        
			        foreach($friends AS $friend) {
				        $checkFriend = $this->User->find('first',
										 array('conditions' => array('User.userId' => $friend['id'])));
			        	if(empty($checkFriend)){
				            $this->User->create();
					        $this->User->saveField('userId', $friend['id']);
					        $this->User->saveField('firstName', $friend['first_name']);
					        $this->User->saveField('lastName', $friend['last_name']);
					        if(isset($friend['gender'])){
						        $this->User->saveField('gender', $friend['gender']);
					        }
					        if(isset($friend['username'])){
					        	$this->User->saveField('userName', $friend['username']);
					        }
					        
					        $this->UserFriend->create();
					        $this->UserFriend->saveField('userId',$userID);
					        $this->UserFriend->saveField('friendId',$friend['id']);
				        }
			        }
				}
			}
   		}
		
	    public function view($id) {
	        if (!$id) {
	            throw new NotFoundException(__('Invalid post'));
	        }
	
	        $user = $this->User->findById($id);
	        if (!$user) {
	            throw new NotFoundException(__('Invalid post'));
	        }
	        $this->set('user', $user);
	    }
	
	    public function add() {
	        if ($this->request->is('post')) {
	            $this->User->create();
	            if ($this->User->save($this->request->data)) {
	                $this->Session->setFlash(__('Your post has been saved.'));
	                return $this->redirect(array('action' => 'index'));
	            }
	            $this->Session->setFlash(__('Unable to add your post.'));
	        }
	    }
	}
	
	function object_to_array($data)
		{
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