Imports System.Text.RegularExpressions

Public Class Cave
    Property _regex As Regex = New Regex("Valve ([A-Z]+) has flow rate=([0-9]+); tunnels? leads? to valves? (.*)")
    Public Property Rooms As Dictionary(Of String, Room) = New Dictionary(Of String, Room)
    Public Property Distances = new Dictionary(Of String, Dictionary(Of String, Integer))
    
    Public Sub ParseRoomLine(roomLine As String)
        Dim match = _regex.Match(roomLine)
        Dim roomName = match.Groups(1).Value
        Dim valveValue = Convert.ToInt32(match.Groups(2).Value)
        Dim leadsTo = match.Groups(3).Value.Split(",").Select(function(s) s.Trim()).ToArray()
        Rooms.Add(roomName, New Room(valveValue, leadsTo))
    End Sub
    
    Public Sub Print()
        For Each kvp as KeyValuePair(Of String, Room) in Rooms
            Console.WriteLine("Valve {0} has flow rate={1}", kvp.Key, kvp.Value.FlowRate)
        Next
    End Sub
    
    Public Function ValuesWorthOpening() As Integer
        Return Rooms.Where(function(pair) pair.Value.FlowRate > 0).Count
    End Function
    
    Public Function NonZeroRooms() As List(Of String)
        Return Rooms.Where(function(pair) pair.Value.FlowRate > 0).Select(function(pair) pair.Key).ToList()
    End Function
    
    Public Function GetPathsForDistance(dist As Integer) As List(Of Path)
        Dim visited = new List(Of String)
        visited.Add("AA")
        Dim start = new Path("AA", new List(Of String), NonZeroRooms(), 0, 0)
        Dim paths = new List(Of Path)
        Dim toProcess = new Queue(Of Path)
        toProcess.Enqueue(start)
        
        While toProcess.Count > 0
            Dim p = toProcess.Dequeue()
            paths.Add(p)
            Dim followUps = p.FollowUpPaths(Me, dist)
            followUps.ForEach(sub(path) toProcess.Enqueue(path))
        End While

        return paths
    End Function
    
    Public Sub BuildDistanceMatrix()
        For Each room in Rooms
            Distances(room.Key) = BuildDistanceList(room.Key)
        Next
    End Sub
    
    Private Function BuildDistanceList(forRoom As String) As Dictionary(Of String, Integer)
        Dim distanceList = new Dictionary(Of String, Integer)
        Dim roomsToCheck = new Queue(Of (String, Integer))
        roomsToCheck.Enqueue((forRoom, 0))

        While roomsToCheck.Count > 0
            Dim nextRoom = roomsToCheck.Dequeue()
            Dim room = Rooms.Item(nextRoom.Item1)
            If Not distanceList.ContainsKey(nextRoom.Item1)
                distanceList.Add(nextRoom.Item1, nextRoom.Item2)
                For Each moveTo in room.LeadsTo
                    roomsToCheck.Enqueue((moveTo, nextRoom.Item2 + 1))
                Next
            End If
        End While
        
        Return distanceList
    End Function
End Class