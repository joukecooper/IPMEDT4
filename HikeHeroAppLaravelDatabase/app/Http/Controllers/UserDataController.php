<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\UserData;

class UserDataController extends Controller
{
    protected function findOrCreateUser($userSeed)
    {
        $userData = UserData::where('user_seed', $userSeed)->first();

        if (!$userData) {
            // Create a new user if not found
            $userData = new UserData();
            $userData->user_seed = $userSeed;
            $userData->username = $userSeed;
            $userData->save();
        }

        return $userData;
    }

    public function createUser(Request $request)
    {
        $request->validate([
            'username' => 'required|string|unique:user_data,username',
            'user_seed' => 'required|string|unique:user_data,user_seed',
        ]);

        try {
            $userData = new UserData();
            $userData->username = $request->input('username');
            $userData->user_seed = $request->input('user_seed');
            $userData->save();

            return response()->json(['message' => 'User created successfully', 'user' => $userData], 201);
        } catch (ValidationException $e) {
            return response()->json(['message' => 'Validation error', 'errors' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Server error'], 500);
        }
    }


    public function getUsername($userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);
        
        if ($userData) {
            return response()->json(['username' => $userData->username]);
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }
    
    public function setUsername(Request $request, $userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);
        
        if ($userData) {
            $userData->username = $request->input('username');
            $userData->save();
            
            return response()->json(['message' => 'Username updated successfully']);
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }

    public function getCoins($userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);
        
        if ($userData) {
            return response()->json(['coins' => $userData->coins]);
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }
    
    public function addCoins(Request $request, $userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);
        
        if ($userData) {
            $coinsToAdd = $request->input('coins', 0);
            $userData->coins += $coinsToAdd;
            $userData->save();
            
            return response()->json(['message' => 'Coins added successfully']);
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }
    
    public function removeCoins(Request $request, $userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);
        
        if ($userData) {
            $coinsToRemove = $request->input('coins', 0);
            $userData->coins -= $coinsToRemove;
            if ($userData->coins < 0) {
                $userData->coins = 0;
            }
            $userData->save();
            
            return response()->json(['message' => 'Coins removed successfully']);
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }

    public function getStreakCount($userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);
        
        if ($userData) {
            return response()->json(['streak_count' => $userData->streak_count]);
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }
    
    public function addStreakCount($userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);
        
        if ($userData) {
            $userData->streak_count++;
            $userData->save();
            
            return response()->json(['message' => 'Streak count incremented successfully']);
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }
    
    public function resetStreakCount($userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);
        
        if ($userData) {
            $userData->streak_count = 0;
            $userData->save();
            
            return response()->json(['message' => 'Streak count reset successfully']);
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }

    public function getTotalDistanceWalked($userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);
        
        if ($userData) {
            return response()->json(['total_distance_walked' => $userData->total_distance_walked]);
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }
    
    public function addTotalDistanceWalked(Request $request, $userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);
        
        if ($userData) {
            $distanceWalked = $request->input('distance_walked', 0);
            $userData->total_distance_walked += $distanceWalked;
            $userData->save();
            
            return response()->json(['message' => 'Total distance walked updated successfully']);
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }
    
    public function resetTotalDistanceWalked($userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);
        
        if ($userData) {
            $userData->total_distance_walked = 0;
            $userData->save();
            
            return response()->json(['message' => 'Total distance walked reset successfully']);
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }

    //get distance_walked_per_day
    //update distance_walked_per_day
    //clean distance_walked_per_day

    public function getFriendsById($userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);

        if ($userData) {
            $rawData = $userData->friends_by_id;
            $processedData = explode(";", $rawData);

            return response()->json(['friends_by_id' => $processedData]);
        } else {
            return response()->json(['message' => 'User not found or has no friends in list'], 404);
        }
    }
    
    public function addFriendsById(Request $request, $userSeed)
    {
        try {
            $friendUsername = $request->input('friendUsername', 0);
            $friendData = UserData::where('username', $friendUsername)->first();

            if ($friendData !== null) {
                $friendId = $friendData->user_seed;

                $userData = $this->findOrCreateUser($userSeed);

                if ($userData->friends_by_id !== null) {
                    $userData->friends_by_id = $userData->friends_by_id . ';' . $friendId;
                } else {
                    $userData->friends_by_id = $friendId;
                }

                $userData->save();

                return response()->json(['message' => 'Friend added successfully']);
            } else {
                return response()->json(['message' => 'Username not found'], 400);
            }
        } catch (Exception $e) {
            return response()->json(['message' => 'Server fault'], 500);
        }
    }
    
    public function removeFriendById(Request $request, $userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);

        if ($userData) {
            $friendIdToRemove = $request->input('friend_id');
            $currentFriends = $userData->friends_by_id;

            if (!empty($currentFriends)) {
                $friendsArray = explode(';', $currentFriends);

                if (($key = array_search($friendIdToRemove, $friendsArray)) !== false) {
                    unset($friendsArray[$key]);
                    $friendsArray = array_values($friendsArray);
                }

                $updatedFriends = implode(';', $friendsArray);
                $userData->friends_by_id = $updatedFriends;
                $userData->save();

                return response()->json(['message' => 'Friend ID removed successfully']);
            } else {
                return response()->json(['message' => 'The friends list is already empty']);
            }
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }
    
    public function countTotalFriends($userSeed)
    {
        $userData = $this->findOrCreateUser($userSeed);

        if ($userData) {
            $currentFriends = $userData->friends_by_id;

            if (!empty($currentFriends)) {
                $friendsArray = explode(';', $currentFriends);
                $totalFriends = count($friendsArray);

                return response()->json(['total_friends' => $totalFriends]);
            } else {
                return response()->json(['total_friends' => 0]);
            }
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }

    public function getTopUsersByCoins()
    {
        $topUsers = UserData::orderByDesc('coins')->take(10)->get();

        return response()->json(['top_users' => $topUsers]);
    }

    public function getTopFriendsWithUser($userSeed)
    {
        // Find the user's data
        $user = $this->findOrCreateUser($userSeed);

        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        // Get the user's friends IDs
        $friendsIds = explode(';', $user->friends_by_id);

        if (empty($friendsIds)) {
            return response()->json(['message' => 'User has no friends'], 404);
        }

        // Get the top 10 users by coins who are friends
        $topFriends = UserData::whereIn('user_seed', $friendsIds)
                        ->orderByDesc('coins')
                        ->take(10)
                        ->get();

        // Check if the user is in the top 10 friends
        $userInTop = $topFriends->contains('user_seed', $userSeed);

        // If user is not in top 10 and exists, include them
        if (!$userInTop && $user) {
            $user->coins = $user->coins ?? 0; // Ensure user's coins are set if not already
            $topFriends->push($user); // Add user to the collection
            $topFriends = $topFriends->sortByDesc('coins')->take(10); // Re-sort to maintain top 10
        }

        return response()->json(['top_friends' => $topFriends]);
    }

    public function getUserCoinsAndNeighbors($userSeed)
    {

        $user = $this->findOrCreateUser($userSeed);

        // Find the user and users with coins just above and below in rank
        $userCoins = $user->coins;

        // User above (higher coins)
        $userAbove = UserData::where('coins', '>', $userCoins)
                        ->orderBy('coins')
                        ->first();

        // User below (lower coins)
        $userBelow = UserData::where('coins', '<', $userCoins)
                        ->orderByDesc('coins')
                        ->first();

        return response()->json([
            'user_coins' => $userCoins,
            'user_above' => $userAbove ? $userAbove->coins : null,
            'user_below' => $userBelow ? $userBelow->coins : null,
        ]);
    }
}
