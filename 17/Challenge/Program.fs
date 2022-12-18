open System
open System.Collections.Generic

type Block =
    struct
       val coversPoints: (int*int) list
       new (coversPoints) = { coversPoints = coversPoints }
    end

type State =
    struct
       val PointsTaken: (int*int) list
       val CurrentBlockPos: int*int
       val HighestBlock: int
       val BlocksFallen: int
       val CurrentBlock: Block
       val BlockList: Block list
       val StreamList: Char list
       val streamsDone: int
       
       new (pointsTaken, currentBlockPos, highestBlock, blocksFallen, currentBlock, blockList, streamList, streamsDone) = {
           PointsTaken = pointsTaken; CurrentBlockPos = currentBlockPos; HighestBlock = highestBlock
           BlocksFallen = blocksFallen; CurrentBlock = currentBlock; BlockList = blockList
           StreamList = streamList; streamsDone = streamsDone
       }
    end
    
let doBlockFall(state: State) =
    let mutable blockX, blockY = state.CurrentBlockPos
    let mutable streamsConsumed = state.streamsDone
    let mutable blockBlocked = false
    let pointsTaken = (Set.ofList state.PointsTaken)
    let mutable state = state
    
    while not blockBlocked do
        (* Move with the stream *)
        let dX = if state.StreamList[streamsConsumed % state.StreamList.Length].Equals '<' then -1 else 1
        let requiredFreePoints = state.CurrentBlock.coversPoints |> List.map (fun (x, y) -> (x + blockX + dX, y + blockY))
        let requiredPointsTaken = Set.intersect (Set.ofList requiredFreePoints) pointsTaken
        let blocksOutsideGrid = requiredFreePoints |> List.filter(fun (x, _) -> x < 1 || x > 7) |> List.toArray
        streamsConsumed <- streamsConsumed + 1
        
        if blocksOutsideGrid.Length = 0 && requiredPointsTaken.Count = 0 then
            blockX <- blockX + dX
        
        (* Move down *)
        let requiredFreePointsDown = state.CurrentBlock.coversPoints |> List.map (fun (x, y) -> (x + blockX, y + blockY - 1))
        let requiredPointsTakenDown = Set.intersect (Set.ofList requiredFreePointsDown) pointsTaken
        if blockY <= 1 || requiredPointsTakenDown.Count > 0 then
            let extraBlocksTaken = state.CurrentBlock.coversPoints |> List.map (fun (x, y) -> (x + blockX, y + blockY))
            let blockReach = extraBlocksTaken |> List.map snd |> List.max
            let highestBlock = max state.HighestBlock blockReach
            state <- State(state.PointsTaken @ extraBlocksTaken, (3, highestBlock + 4), highestBlock, state.BlocksFallen + 1,
              state.BlockList[(state.BlocksFallen + 1) % 5], state.BlockList, state.StreamList, streamsConsumed)
            blockBlocked <- true
        else
            blockY <- blockY - 1
    
    state
    
let buildStateDescription (state: State) =
    let mutable description = ""
    for i in state.HighestBlock .. -1 .. state.HighestBlock - 10 do
        for j in 1 .. 7 do
            if List.contains (j, i) state.PointsTaken then
                description <- description + "1"
            else
                description <- description + "0"
            
    let streamString = $"%d{state.streamsDone % state.StreamList.Length}"
    let blockString = $"%d{state.BlocksFallen % 5}"
    description + "-" + streamString + "-" + blockString 
            
    
let getStateAfterBlocksFell(state: State, numBlocks: int64) =
    let mutable state = state
    let stateStr = buildStateDescription state
    let mutable states = Dictionary<string, State>()
    let mutable scores = Dictionary<int, int>()
    states.Add(stateStr, state)
    
    let mutable counter = 1L
    while counter <= numBlocks do
        state <- doBlockFall state
        printf $"Highest after %d{state.BlocksFallen} blocks: %d{state.HighestBlock}\n"
        
        scores.Add(state.BlocksFallen, state.HighestBlock)
        
        let stateKey = buildStateDescription state
       
        if states.ContainsKey stateKey then
            let otherState = states.Item stateKey
            printfn $"This state equals a state seen before (blocks fallen: %d{otherState.BlocksFallen}, highest block: %d{otherState.HighestBlock}"
            
            let blocksDiff  = state.BlocksFallen - otherState.BlocksFallen
            let scoreDiff = state.HighestBlock - otherState.HighestBlock
            
            counter <- numBlocks + 1L
            
            let diffToFill = numBlocks - int64 state.BlocksFallen
            let timesDiffToAdd = diffToFill / int64 blocksDiff
            let remainder = diffToFill - (timesDiffToAdd * int64 blocksDiff)
            
            let scorePt1 = int64 state.HighestBlock + (timesDiffToAdd * int64 scoreDiff)
            let scorePt2 = scores[otherState.BlocksFallen + int remainder] - scores[otherState.BlocksFallen]
            
            printfn $"Calculated end score: %d{scorePt1 + int64 scorePt2}"
        else
            states.Add(stateKey, state)
        
        counter <- counter + 1L
    state

let printState(state: State) =
    for i in state.HighestBlock + 2 .. -1 .. 1 do
        for j in 1 .. 7 do
            if List.contains (j, i) state.PointsTaken then
                printf "#"
            else
                printf "."
        printf "\n"

let horizontalBlock = Block([(0,0); (1,0); (2,0); (3,0)])            
let plusBlock = Block([(1,0); (0,1); (1,1); (2,1); (1,2)])
let lBlock = Block([(0,0); (1,0); (2,0); (2,1); (2,2)])
let verticalBlock = Block([(0,0); (0,1); (0,2); (0,3)])
let squareBlock = Block([(0,0); (1,0); (0,1); (1,1)])

let stream = Seq.toList ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

let state = State([], (3,4), 0, 0, horizontalBlock, [horizontalBlock; plusBlock; lBlock; verticalBlock; squareBlock], stream, 0)
let finalState = getStateAfterBlocksFell(state, 1000000000000L)