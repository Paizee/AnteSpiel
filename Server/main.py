import asyncio
from datetime import datetime, timedelta
import websockets
import json


lobbys = []

class user:
    def __init__(self, name, role, points):
        self.name = name
        self.role = role
        self.points = points
        
    def update_points(self, points):
        self.points += points

class lobby:
    def __init__(self, code, user,state,endtime):
        self.code = code
        self.user = user
        self.state = state
        self.endtime = endtime
    def add_user(self,user):
        self.user.append(user)
    
    def find_lobby_index(self, code):
        for index, lobby in enumerate(lobbys):
            if lobby.code == code:
                return index
        return -1
    
    def remove_user(self, username):
        for user in self.user:
            if user.name == username:
                self.user.remove(user)
                return True  # User removed successfully
        return False # User not found
    
    def get_user_count(self):
        return len(self.user)

    def change_to_start(self,time):
        self.state = "started"
        self.endtime = time
        
    def increment_points(self,username,points):
        for user in self.user:
            if user.name == username:
                user.update_points(points)

def convert_to_dict(obj):
    if isinstance(obj, (user, lobby)):
        return obj.__dict__
    return obj

def make_a_lobby(code,username):

    lobbys.append((lobby(code,[user(username,"Admin",0)],"not_started","")))
    
def connect_to_lobby(code,username):
    index = lobby("", "","","").find_lobby_index(code)
    lobbys[index].add_user(user(username,"Nutzer",0))

def left_lobby(code,username,role):
    index = lobby("", "","","").find_lobby_index(code)
    lobbys[index].remove_user(username) 
    if lobbys[index].get_user_count() :
        lobbys[index].remove()

def start_lobby(code):
    time = datetime.utcnow() + timedelta(minutes=5)

    index = lobby("", "","","").find_lobby_index(code)
    lobbys[index].change_to_start(str(time))
    
def increment_points(code,username,points):
    index = lobby("", "","","").find_lobby_index(code)
    lobbys[index].increment_points(username,points)

async def handle_websocket(websocket):
    async for message in websocket:
        # Parse the received JSON data
        data = json.loads(message)
        if "lobby" in data: 
            if data["lobby"] == "create":  
                make_a_lobby(data["code"],data["name"])
            elif data["lobby"] == "join":
                connect_to_lobby(data["code"],data["name"]) 
        if "action" in data:
            if data["action"] == "return_lobbys":
                json_string = json.dumps(lobbys, default=convert_to_dict, indent=2)    
                await websocket.send(json_string)
            if data["action"] == "left_lobby":
                left_lobby(data["code"],data["name"],data["role"])
            if data["action"] == "start_lobby":
                start_lobby(data["code"])
            if data["action"] == "increment_points":
                increment_points(data["code"],data["username"],data["points"])
            if data["action"] == "check_connection":
                json_string = json.dumps(lobbys, default=convert_to_dict, indent=2)    
                await websocket.send(json_string)

start_server = websockets.serve(handle_websocket, "0.0.0.0", 8765, ping_timeout=None)

# Run the event loop
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()