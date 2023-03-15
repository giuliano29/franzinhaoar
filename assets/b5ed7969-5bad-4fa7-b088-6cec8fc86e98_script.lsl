//start_unprocessed_text
/*key p1 = NULL_KEY;
key p2 = NULL_KEY;
key p3 = NULL_KEY;
key p4 = NULL_KEY;
key p5 = NULL_KEY;
key p6 = NULL_KEY;
key p7 = NULL_KEY;
key p8 = NULL_KEY;

string p1_name;
string p2_name;
string p3_name;
string p4_name;
string p5_name;
string p6_name;
string p7_name;
string p8_name;

integer p1_stars;
integer p2_stars;
integer p3_stars;
integer p4_stars;
integer p5_stars;
integer p6_stars;
integer p7_stars;
integer p8_stars;

integer p1_score;
integer p2_score;
integer p3_score;
integer p4_score;
integer p5_score;
integer p6_score;
integer p7_score;
integer p8_score;
integer player_count;
integer player_turn;
integer current_id;
integer rolled = FALSE;

integer p1_id;
integer p2_id;
integer p3_id;
integer p4_id;
integer p5_id;
integer p6_id;
integer p7_id;
integer p8_id;

/|/ 3-face prim constants
list FACES = [4,0,2];
list ROTS = [90,0,270];

key TEXTURE = "012eaa6f-fed9-4c13-ab3a-28f426113857";
key TEXTURE_USED = "012eaa6f-fed9-4c13-ab3a-28f426113857";

/|/ Dice states
integer STATE_UNUSED = 2002000; /|/ default
integer STATE_CHOSEN = 2002001; /|/ yellow
integer STATE_SET = 2002002;    /|/ blue

/|/ Texture constants
integer TEXTURE_LOGO = 0;
integer TEXTURE_DICE_OFFSET = 1;
integer TEXTURE_BUSTED = 7;

/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/
/|/ Global variable declarations
/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/
integer gScoreToBeat = 10000;
float gVolume = 1.0;
integer gRoundTime = 120;
/|/integer hidden_channel = -174996;
key high_score_player = NULL_KEY;
key gCurrentPlayer = NULL_KEY;  /|/ current player
integer gTotalScore;            /|/ current score
integer gGameOver = FALSE;

/|/ Current round variables
integer gRoundTimeElapsed;
integer gRoundScore;
integer gStarCount;
list gCurrentDice;  /|/ strided list {dice number, state}
integer gRoundOver = FALSE;
integer gSafeNumber;    /|/this is a safe number that can be chosen and won't be busted
integer final = FALSE;

/|/ Links
integer gDicePrim0;
integer gDicePrim1;
integer main;
integer points_prim;
integer options_prim;
integer to_win;
key diceroll         = "d163a741-5bd3-40c1-b950-2a277debb2f3";
key player_won       = "48bef746-09cd-4f4e-9df3-8e26b46a8794";
key next_turn        = "ad62678d-6c9a-4640-8d65-a568a35d25bc";

/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/
/|/ User defined functions
/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/
integer random_integer( integer min, integer max )
{
    return min + (integer)( llFrand( max - min + 1 ) );
}

integer setTexture(integer _linkNumber, integer _face, integer _textureNumber)
{
    llSetLinkPrimitiveParamsFast(_linkNumber,[PRIM_TEXTURE,llList2Integer(FACES,_face),TEXTURE, <0.25,0.25,0.0>, <-.375+0.25*(_textureNumber%4), 0.375-0.25*(_textureNumber/4), 0.0>, llList2Integer(ROTS,_face)*DEG_TO_RAD]);
    return 1;
}

enumeratePrims()
{
    integer linkIndex = llGetNumberOfPrims();
    for (;linkIndex >= 1; --linkIndex)
    {
        string linkName = llGetLinkName(linkIndex);
        if (linkName == "D1") gDicePrim0 = linkIndex;
        else if (linkName == "D2") gDicePrim1 = linkIndex;
        else if (linkName == "center") main = linkIndex;  /|/ xyzzytext-0-0
        else if (linkName == "options") options_prim = linkIndex;
        else if (linkName == "to_win") to_win = linkIndex;
        else if (linkName == "points") points_prim = linkIndex;

        else if (linkName == "p1") p1_id = linkIndex;
        else if (linkName == "p2") p2_id = linkIndex;
        else if (linkName == "p3") p3_id = linkIndex;
        else if (linkName == "p4") p4_id = linkIndex;
        else if (linkName == "p5") p5_id = linkIndex;
        else if (linkName == "p6") p6_id = linkIndex;
        else if (linkName == "p7") p7_id = linkIndex;
        else if (linkName == "p8") p8_id = linkIndex;
    }
}

key theNumbers = "fc8f3317-9f84-4e7d-b9fc-919f09da8e10";
key theTrans   = "8dcd4a48-2d37-4909-9f78-f7a9eb4ef903";

showScore(integer link, integer score)
{
    if (score==-1)
    {
        llSetLinkPrimitiveParamsFast(link, [PRIM_TEXTURE, 1, theNumbers, <0.17, 1., 1.>, <0.405, 0., 0.>, 0.,
                PRIM_TEXTURE, 6, theNumbers, <0.068, 1., 1.>, <0.388, 0., 0.>, 0.,
                PRIM_TEXTURE, 4, theNumbers, <-1.122, 1., 1.>, <0.851, 0., 0.>, 0.,
                PRIM_TEXTURE, 7, theNumbers, <0.068, 1., 1.>, <0.265, 0., 0.>, 0.,
                PRIM_TEXTURE, 3, theNumbers, <0.17, 1., 1.>, <0.243, 0., 0.>, 0.]);
    }
    else
    {
        integer v1=score%10;
        integer v2=(score/10)%10;
        integer v3=(score/100)%10;
        integer v4=(score/1000)%10;
        integer v5=(score/10000)%10;
        key texture1 = theNumbers;
        key texture2 = theNumbers;
        key texture3 = theNumbers;
        key texture4 = theNumbers;
        key texture5 = theNumbers;
        if (score <10)
            texture2=theTrans;
        if (score <100)
            texture3=theTrans;
        if (score <1000)
            texture4=theTrans;
        if (score <10000)
            texture5=theTrans;
        llSetLinkPrimitiveParamsFast(link, [PRIM_TEXTURE, 1, texture1, <0.17, 1., 1.>, <-0.521 + 0.0642222 * v1, 0., 0.>, 0.,
                PRIM_TEXTURE, 6, texture2, <0.068, 1., 1.>, <-0.4657 + 0.0642222 * v2, 0., 0.>, 0.,
                PRIM_TEXTURE, 4, texture3, <-1.122, 1., 1.>, <-0.941 + 0.0642222 * v3, 0., 0.>, 0.,
                PRIM_TEXTURE, 7, texture4, <0.068, 1., 1.>, <-0.4567 + 0.0642222 * v4, 0., 0.>, 0.,
                PRIM_TEXTURE, 3, texture5, <0.17, 1., 1.>, <-0.416 + 0.0642222 * v5, 0., 0.>, 0.]);
    }
}

setDiceTexture(integer _diceNumber, integer _texture)
{
    if (_diceNumber < 3) setTexture(gDicePrim0,_diceNumber,_texture);
    else setTexture(gDicePrim1,_diceNumber-3,_texture);
}

setColor(integer _diceNumber)
{
    integer diceState = llList2Integer(gCurrentDice,_diceNumber*2+1);
    integer dicePrim = gDicePrim0;
    if (_diceNumber > 2)
    {
        _diceNumber -= 3;
        dicePrim = gDicePrim1;
    }

    vector diceColor;
    if (diceState == STATE_UNUSED) diceColor = <1,1,1>;
    else if (diceState == STATE_CHOSEN) diceColor = <0.4,0.4,0.4>;
    else if (diceState == STATE_SET) diceColor = <0.4,0.0,0.0>;
    llSetLinkColor(dicePrim,diceColor,llList2Integer(FACES,_diceNumber));
}

textureAll(integer _texture)
{
    integer i = 0;
    for (;i < 6; ++i)
        setDiceTexture(i,_texture);
}

game_over()
{
    if (gGameOver)
      return;
      llParticleSystem(
                [
                    PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_EXPLODE,
                    PSYS_SRC_BURST_RADIUS,1.1,
                    PSYS_SRC_ANGLE_BEGIN,0,
                    PSYS_SRC_ANGLE_END,0,
                    PSYS_SRC_TARGET_KEY,llGetKey(),
                    PSYS_PART_START_COLOR,<1.000000,1.000000,1.000000>,
                    PSYS_PART_END_COLOR,<1.000000,1.000000,1.000000>,
                    PSYS_PART_START_ALPHA,1,
                    PSYS_PART_END_ALPHA,1,
                    PSYS_PART_START_GLOW,0.5,
                    PSYS_PART_END_GLOW,0.5,
                    PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
                    PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
                    PSYS_PART_START_SCALE,<0.100000,0.100000,0.100000>,
                    PSYS_PART_END_SCALE,<0.300000,0.300000,0.300000>,
                    PSYS_SRC_TEXTURE,"9453a1b6-0a64-4e03-a89e-047705fc56ef",
                    PSYS_SRC_MAX_AGE,3,
                    PSYS_PART_MAX_AGE,5,
                    PSYS_SRC_BURST_RATE,0.1,
                    PSYS_SRC_BURST_PART_COUNT,51,
                    PSYS_SRC_ACCEL,<0.000000,0.000000,-0.600000>,
                    PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
                    PSYS_SRC_BURST_SPEED_MIN,1.2,
                    PSYS_SRC_BURST_SPEED_MAX,2,
                    PSYS_PART_FLAGS,
                        0 |
                        PSYS_PART_BOUNCE_MASK |
                        PSYS_PART_FOLLOW_VELOCITY_MASK
                ]);
                
                llSleep(4);
                
                llParticleSystem([]);

    if (player_count <= 0)
    {
        llWhisper(0, "All players left, game resetting.");
    }
    else if (high_score_player)
    {
        llTriggerSound(player_won, gVolume);
        llWhisper(0, "Congrats " + llKey2Name(high_score_player) + " you have just won the game.");
    }
     

/|/    integer scored;
/|/
/|/    if (high_score_player == p1)
/|/        scored = p1_score;
/|/    if (high_score_player == p2)
/|/        scored = p2_score;
/|/    if (high_score_player == p3)
/|/        scored = p3_score;
/|/    if (high_score_player == p4)
/|/        scored = p4_score;
/|/    if (high_score_player == p5)
/|/        scored = p5_score;
/|/    if (high_score_player == p6)
/|/        scored = p6_score;
/|/    if (high_score_player == p7)
/|/        scored = p7_score;
/|/    if (high_score_player == p8)
/|/        scored = p8_score;


    gGameOver = TRUE;
    llMessageLinked(LINK_SET, 4444, "", "");
}

string star_convert(integer stars)
{
    string s;

    if (stars == 1)
        s = "*";
    else if (stars == 2)
        s = "*|*";

    return s;
}

show_scores()
{
    if (p1)
        llSetLinkPrimitiveParamsFast(p1_id, [ PRIM_TEXT, llKey2Name(p1) + star_convert(p1_stars) +"\n"+ (string)p1_score, <1,1,1>, 1.0] );
    if (p2)
        llSetLinkPrimitiveParamsFast(p2_id, [ PRIM_TEXT, llKey2Name(p2) + star_convert(p2_stars) +"\n"+ (string)p2_score, <1,1,1>, 1.0] );
    if (p3)
        llSetLinkPrimitiveParamsFast(p3_id, [ PRIM_TEXT, llKey2Name(p3) + star_convert(p3_stars) +"\n"+ (string)p3_score, <1,1,1>, 1.0] );
    if (p4)
        llSetLinkPrimitiveParamsFast(p4_id, [ PRIM_TEXT, llKey2Name(p4) + star_convert(p4_stars) +"\n"+ (string)p4_score, <1,1,1>, 1.0] );
    if (p5)
        llSetLinkPrimitiveParamsFast(p5_id, [ PRIM_TEXT, llKey2Name(p5) + star_convert(p5_stars) +"\n"+ (string)p5_score, <1,1,1>, 1.0] );
    if (p6)
        llSetLinkPrimitiveParamsFast(p6_id, [ PRIM_TEXT, llKey2Name(p6) + star_convert(p6_stars) +"\n"+ (string)p6_score, <1,1,1>, 1.0] );
    if (p7)
        llSetLinkPrimitiveParamsFast(p7_id, [ PRIM_TEXT, llKey2Name(p7) + star_convert(p7_stars) +"\n"+ (string)p7_score, <1,1,1>, 1.0] );
    if (p8)
        llSetLinkPrimitiveParamsFast(p8_id, [ PRIM_TEXT, llKey2Name(p8) + star_convert(p8_stars) +"\n"+ (string)p8_score, <1,1,1>, 1.0] );

    /|/ NO PLAYERS
    if (p1 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p1_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p2 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p2_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p3 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p3_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p4 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p4_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p5 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p5_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p6 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p6_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p7 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p7_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p8 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p8_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
}

do_score(integer score, integer stars)
{
    if (gCurrentPlayer == p1)
    {
        p1_score = score;
        p1_stars = stars;
        setScore(p1_id, p1_score, p1_stars);
    }
    else if (gCurrentPlayer == p2)
    {
        p2_score = score;
        p2_stars = stars;
        setScore(p2_id, p2_score, p2_stars);
    }
    else if (gCurrentPlayer == p3)
    {
        p3_score = score;
        p3_stars = stars;
        setScore(p3_id, p3_score, p3_stars);
    }
    else if (gCurrentPlayer == p4)
    {
        p4_score = score;
        p4_stars = stars;
        setScore(p4_id, p4_score, p4_stars);
    }
    else if (gCurrentPlayer == p5)
    {
        p5_score = score;
        p5_stars = stars;
        setScore(p5_id, p5_score, p5_stars);
    }
    else if (gCurrentPlayer == p6)
    {
        p6_score = score;
        p6_stars = stars;
        setScore(p6_id, p6_score, p6_stars);
    }
    else if (gCurrentPlayer == p7)
    {
        p7_score = score;
        p7_stars = stars;
        setScore(p7_id, p7_score, p7_stars);
    }
    else if (gCurrentPlayer == p8)
    {
        p8_score = score;
        p8_stars = stars;
        setScore(p8_id, p8_score, p8_stars);
    }

    show_scores();
}

integer getLinkDescScore(integer LINK)
{
    list params = llGetLinkPrimitiveParams(LINK, [PRIM_DESC]);
    list data = llCSV2List(llList2String(params, 0));
    return llList2Integer(data, 0);
}

integer getLinkDescStars(integer LINK)
{
    list params = llGetLinkPrimitiveParams(LINK, [PRIM_DESC]);
    list data = llCSV2List(llList2String(params, 0));
    return llList2Integer(data, 1);
}

setScore(integer link, integer score, integer stars)
{
    llSetLinkPrimitiveParamsFast(link, [PRIM_DESC, (string)score +","+ (string)stars]);
}

clear()
{
    llSetLinkColor(p1_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p2_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p3_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p4_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p5_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p6_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p7_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p8_id, <1,0.7,0.5>, 2);

    setScore(p1_id, 0,0);
    setScore(p2_id, 0,0);
    setScore(p3_id, 0,0);
    setScore(p4_id, 0,0);
    setScore(p5_id, 0,0);
    setScore(p6_id, 0,0);
    setScore(p7_id, 0,0);
    setScore(p8_id, 0,0);
}

next_player()
{
    if (gGameOver)
      return;

    llSetLinkColor(current_id, <1,0.7,0.5>, 2);
    llTriggerSound(next_turn, gVolume);
    /|/llOwnerSay("Player Turn " + (string)player_turn);
    gCurrentPlayer = NULL_KEY;
    gTotalScore = 0;
    gStarCount = 0;

    if (player_count <= 0)
    {
        game_over();
    }
    else
    {
        if (player_turn == 0 && p1 != NULL_KEY)
        {
            /|/llOwnerSay("checking 1");
            gCurrentPlayer = p1;
            current_id = p1_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p1_id);
            gStarCount = getLinkDescStars(p1_id);
        }

        if (player_turn == 1 && p2 != NULL_KEY)
        {
            /|/llOwnerSay("checking 2");
            gCurrentPlayer = p2;
            current_id = p2_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p2_id);
            gStarCount = getLinkDescStars(p2_id);
        }

        if (player_turn == 2 && p3 != NULL_KEY)
        {
            /|/llOwnerSay("checking 3");
            gCurrentPlayer = p3;
            current_id = p3_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p3_id);
            gStarCount = getLinkDescStars(p3_id);
        }

        if (player_turn == 3 && p4 != NULL_KEY)
        {
            /|/llOwnerSay("checking 4");
            gCurrentPlayer = p4;
            current_id = p4_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p4_id);
            gStarCount = getLinkDescStars(p4_id);
        }

        if (player_turn == 4 && p5 != NULL_KEY)
        {
            /|/llOwnerSay("checking 5");
            gCurrentPlayer = p5;
            current_id = p5_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p5_id);
            gStarCount = getLinkDescStars(p5_id);
        }

        if (player_turn == 5 && p6 != NULL_KEY)
        {
            /|/llOwnerSay("checking 6");
            gCurrentPlayer = p6;
            current_id = p6_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p6_id);
            gStarCount = getLinkDescStars(p6_id);
        }

        if (player_turn == 6 && p7 != NULL_KEY)
        {
            /|/llOwnerSay("checking 7");
            gCurrentPlayer = p7;
            current_id = p7_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p7_id);
            gStarCount = getLinkDescStars(p7_id);
        }

        if (player_turn == 7 && p8 != NULL_KEY)
        {
            /|/llOwnerSay("checking 8");
            gCurrentPlayer = p8;
            current_id = p8_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p8_id);
            gStarCount = getLinkDescStars(p8_id);
        }

        if (gCurrentPlayer == NULL_KEY)
        {
            player_turn++;

            if(player_turn > 7)
                player_turn = 0;

            next_player();
        }

        /|/llOwnerSay("PT " + (string)player_turn);

        if (gCurrentPlayer == high_score_player && final == TRUE)
        {
            game_over();
        }
    }
}

rollDice()
{
    llPlaySound(diceroll, gVolume);

    /|/llSleep(1.0);
    /|/ Generate new dice for those that are unused
    integer i = 0;
    integer safeGenerated = FALSE;
    for (;i < 6; ++i)
    {
        integer dieState = llList2Integer(gCurrentDice,i*2+1);
        if (dieState == STATE_UNUSED)
        {
            /|/ Generate and color
            integer texture = random_integer(1,6);
            if (texture == gSafeNumber) safeGenerated = TRUE;
            gCurrentDice = llListReplaceList(gCurrentDice,[texture],i*2,i*2);
            setDiceTexture(i, texture + TEXTURE_DICE_OFFSET - 1);
            setColor(i);
        }
    }

    /|/ Figure out if busted
    if (scoreDice(STATE_UNUSED, FALSE, FALSE) == 0 && safeGenerated == FALSE)
    {
        gStarCount++;
        /|/llOwnerSay("Star Count " + (string)gStarCount);
        /|/ PLAY BUSTED SOUND HERE
        gRoundScore = 0;
        gRoundOver = TRUE;
        /|/ llSleep(2);
        llSetLinkColor(gDicePrim0,<0.4,0,0>,ALL_SIDES);
        llSetLinkColor(gDicePrim1,<0.4,0,0>,ALL_SIDES);
        /|/textureAll(TEXTURE_BUSTED);

        if (gStarCount == 3)
        {
            llWhisper(0, "3 Stars. Lost all points");
            gTotalScore = 0;
            gStarCount = 0;
            llPlaySound("ae56373a-70da-411b-9b14-2ba118cac702",1.0);
            
        }

        llSleep(0.5);
        do_score(gTotalScore, gStarCount);
        show_scores();
        /|/ llSleep(2);
        state playing;
    }
}

integer scoreDice(integer _state, integer _strict, integer _newSafe)
{
    list selected = [];
    integer i = 0;
    for (;i<6;++i)
    {
        if (llList2Integer(gCurrentDice,i*2+1) == _state)
            selected += llList2Integer(gCurrentDice,i*2);
    }

    list temp = llListSort(selected,1,TRUE);

    integer totalDice = llGetListLength(temp);
    integer usedDice = 0;
    integer safeNumberCandidate = -1;

    integer fiveused = FALSE;
    integer oneused = FALSE;
    integer totalRoll = 0;


    integer pairCount = 0;
    if (llGetListLength(temp) == 6)
    {
        /|/ check for 3 pairs

        integer j = 1;
        for (;j<=6;++j)
        {
            if (~llListFindList(temp,[j,j])) pairCount++;
        }
    }
    if (pairCount == 3)
    {
        totalRoll += 1500;
        usedDice = 6;
    }

    else if (~llListFindList(temp,[1,2,3,4,5,6]))    {
        totalRoll += 1500; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,2,3,4,5,5]))    {
        totalRoll += 1050; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,2,3,4,5]))    {
        totalRoll += 1100; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,2,3,4,5]))    {
        totalRoll += 1000; /|/other rules say 1500
        usedDice = 5;
         }

    else if (~llListFindList(temp,[2,3,4,5,5,6]))    {
        totalRoll += 1050; /|/other rules say 1500
        usedDice = 6;
        
        
        }
        

    else if (~llListFindList(temp,[2,3,4,5,6]))    {
        totalRoll += 1000; /|/other rules say 1500
        usedDice = 5;
       
        }

    else if (~llListFindList(temp,[1,1,1,1,2,2]))    {
        totalRoll += 2500; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,1,3,3]))    {
        totalRoll += 2500; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,1,4,4]))    {
        totalRoll += 2500; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,1,5,5]))    {
        totalRoll += 2500; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,1,6,6]))    {
        totalRoll += 2500; /|/other rules say 1500
        usedDice = 6;
        
        }

    else if (~llListFindList(temp,[1,1,2,2,2,2]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,2,3,3]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,2,4,4]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,2,5,5]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,2,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,3,3,3,3]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,3,3,3,3]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,3,3,4,4]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,3,3,5,5]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,3,3,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,4,4,4,4]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,4,4,4,4]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,4,4,4,4]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[4,4,4,4,5,5]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[4,4,4,4,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,5,5,5,5]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,5,5,5,5]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,5,5,5,5]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[4,4,5,5,5,5]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[5,5,5,5,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,6,6,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,6,6,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,6,6,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[4,4,6,6,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[5,5,6,6,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,2,2,2]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,3,3,3]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,4,4,4]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,5,5,5]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,6,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,3,3,3]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,4,4,4]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,5,5,5]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,6,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,3,4,4,4]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,3,5,5,5]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,3,6,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[4,4,4,5,5,5]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[4,4,4,6,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
        }

    else if (~llListFindList(temp,[5,5,5,6,6,6]))    {
        totalRoll += 2000; /|/other rules say 1500
        usedDice = 6;
    }
    
    else if (~llListFindList(temp,[1,1,1,1,1,1]))   {
        totalRoll += 8000;
        usedDice = 6;
        llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
        
    }
    else if (~llListFindList(temp,[2,2,2,2,2,2]))   {
        totalRoll += 1600;
        usedDice = 6;
        llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
    }
    else if (~llListFindList(temp,[3,3,3,3,3,3]))   {
        totalRoll += 2400;
        usedDice = 6;
        llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
    }
    else if (~llListFindList(temp,[4,4,4,4,4,4]))   {
        totalRoll += 3200;
        usedDice = 6;
        llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
    }
    else if (~llListFindList(temp,[5,5,5,5,5,5]))   {
        totalRoll += 4000;
        usedDice = 6;
        llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
    }
    else if (~llListFindList(temp,[6,6,6,6,6,6]))   {
        totalRoll += 4800;
        usedDice = 6;
        llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
    }
    else /|/not six of a kind
    {
        integer trySafe = TRUE;
        if (~llListFindList(temp,[1,1,1])) {
            oneused = TRUE;
            totalRoll += 1000;
            usedDice += 3;
            if (~llListFindList(temp,[1,1,1,1]))
            {
                oneused = TRUE;
                totalRoll += 1000;
                usedDice++;
                if (~llListFindList(temp,[1,1,1,1,1]))
                {
                    oneused = TRUE;
                    totalRoll += 2000;
                    usedDice++;
                    llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
                }
            }
        }

        if (~llListFindList(temp,[2,2,2]))
        {
            if (gSafeNumber == 2) trySafe= FALSE;
            totalRoll += 200;
            usedDice += 3;
            safeNumberCandidate = 2;
            if (~llListFindList(temp,[2,2,2,2]))
            {
                totalRoll += 200; /|/400 total
                usedDice++;
                if (~llListFindList(temp,[2,2,2,2,2]))  {
                    totalRoll += 400; /|/800 total
                    usedDice++;
                }
            }
        }

        if (~llListFindList(temp,[3,3,3]))
        {
            if (gSafeNumber == 3) trySafe = FALSE;
            totalRoll += 300;
            usedDice += 3;
            safeNumberCandidate = 3;
            if (~llListFindList(temp,[3,3,3,3]))
            {
                totalRoll += 300; /|/600 total
                usedDice++;
                if (~llListFindList(temp,[3,3,3,3,3]))  {
                    totalRoll += 600; /|/1200 total
                    usedDice++;
                }
            }
        }

        if (~llListFindList(temp,[4,4,4]))
        {
            if (gSafeNumber == 4) trySafe = FALSE;
            totalRoll += 400;
            usedDice += 3;
            safeNumberCandidate = 4;
            if (~llListFindList(temp,[4,4,4,4]))
            {
                totalRoll += 400; /|/800 total
                usedDice++;
                if (~llListFindList(temp,[4,4,4,4,4]))  {
                    totalRoll += 800; /|/1600 total
                    usedDice++;
                }
            }
        }

        if (~llListFindList(temp,[5,5,5]))
        {
            fiveused = TRUE;
            totalRoll += 500;
            usedDice += 3;
            if (~llListFindList(temp,[5,5,5,5]))
            {
                fiveused = TRUE;
                totalRoll += 500;
                usedDice++;
                if (~llListFindList(temp,[5,5,5,5,5]))
                {
                    fiveused = TRUE;
                    totalRoll += 1000;
                    usedDice++;
                }
            }
        }

        if (~llListFindList(temp,[6,6,6]))
        {
            if (gSafeNumber == 6) trySafe = FALSE;
            totalRoll += 600;
            usedDice += 3;
            safeNumberCandidate = 6;
            if (~llListFindList(temp,[6,6,6,6]))
            {
                totalRoll += 600; /|/1200 total
                usedDice++;
                if (~llListFindList(temp,[6,6,6,6,6]))  {
                    totalRoll += 1200; /|/2400 total
                    usedDice++;
                }
            }
        }

        if ((~llListFindList(temp,[5])) && !fiveused)
        {
            totalRoll += 50;
            usedDice++;
            if ((~llListFindList(temp,[5,5])) && !fiveused)   {
                totalRoll += 50;
                usedDice++;
            }
        }
        if ((~llListFindList(temp,[1])) && !oneused)
        {
            totalRoll += 100;
            usedDice++;
            if ((~llListFindList(temp,[1,1])) && !oneused)    {
                totalRoll += 100;
                usedDice++;
            }
        }
        /|/ Safe dice
        if (trySafe == TRUE)    {
            if (~llListFindList(temp,[gSafeNumber])) {
                usedDice++;
                if (~llListFindList(temp,[gSafeNumber,gSafeNumber]))  {
                    usedDice++;
                }
            }
        }

    }
    if (_newSafe == TRUE && safeNumberCandidate != -1) gSafeNumber = safeNumberCandidate;
    if (_strict == TRUE && usedDice != totalDice) return -1;
    else return totalRoll;
}

/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/
/|/ Script state definitions
/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/

default
{
    on_rez(integer _param)
    {
        llResetScript();
    }

    state_entry()
    {
        llMessageLinked(LINK_SET, 5555, "", "");
        state ready;
    }
}

state ready
{
    on_rez(integer _param)
    {
        llResetScript();
    }

    state_entry()
    {
        enumeratePrims();
        clear();
        llSetLinkColor(gDicePrim0,<1,1,1>,ALL_SIDES);
        llSetLinkColor(gDicePrim1,<1,1,1>,ALL_SIDES);
        show_scores();
        textureAll(1);
        showScore(points_prim, 0);
        showScore(to_win, 0);
    }

    touch_end(integer d)
    {
        integer link = llDetectedLinkNumber(0);
        key user = llDetectedKey(0);
        integer face = llDetectedTouchFace(0);

        if (link == options_prim)
        {
            /|/ llOwnerSay("Touched Options Prim");

            if (user == p1 || user == p2 || user == p3 || user == p4 || user == p5 || user == p6 || user == p7 || user == p8)
            {
                /|/  llOwnerSay("User detected, Face: " + (string)face);

                if (face == 2)
                    state playing;
            }
        }
    }

    link_message(integer l, integer n, string m, key id)
    {
        /|/llOwnerSay("Link Message: " + m);

        if (n == 1000)
        {
            if (m == "1001")
            {
                p1 = id;
                p1_name = llKey2Name(p1);
            }
            else if (m == "1002")
            {
                p2 = id;
                p2_name = llKey2Name(p2);
            }
            else if (m == "1003")
            {
                p3 = id;
                p3_name = llKey2Name(p3);
            }
            else if (m == "1004")
            {
                p4 = id;
                p4_name = llKey2Name(p4);
            }
            else if (m == "1005")
            {
                p5 = id;
                p5_name = llKey2Name(p5);
            }
            else if (m == "1006")
            {
                p6 = id;
                p6_name = llKey2Name(p6);
            }
            else if (m == "1007")
            {
                p7 = id;
                p7_name = llKey2Name(p7);
            }
            else if (m == "1008")
            {
                p8 = id;
                p8_name = llKey2Name(p8);
            }

            player_count++;
            llWhisper(0, "Welcome to the game, " + llKey2Name(id) + " press ROLL to start game when all players are ready.");
        }
        else if (n == 1001)
        {
            llWhisper(0, p1_name + " has left the game.");
            p1 = NULL_KEY;
            player_count--;
        }
        else if (n == 1002)
        {
            llWhisper(0, p2_name + " has left the game.");
            p2 = NULL_KEY;
            player_count--;
        }
        else if (n == 1003)
        {
            llWhisper(0, p3_name + " has left the game.");
            p3 = NULL_KEY;
            player_count--;
        }
        else if (n == 1004)
        {
            llWhisper(0, p4_name + " has left the game.");
            p4 = NULL_KEY;
            player_count--;
        }
        else if (n == 1005)
        {
            llWhisper(0, p5_name + " has left the game.");
            p5 = NULL_KEY;
            player_count--;
        }
        else if (n == 1006)
        {
            llWhisper(0, p6_name + " has left the game.");
            p6 = NULL_KEY;
            player_count--;
        }
        else if (n == 1007)
        {
            llWhisper(0, p7_name + " has left the game.");
            p7 = NULL_KEY;
            player_count--;
        }
        else if (n == 1008)
        {
            llWhisper(0, p8_name + " has left the game.");
            p8 = NULL_KEY;
            player_count--;
        }
    }
}

state playing
{
    on_rez(integer x)
    {
        llResetScript();
    }

    state_entry()
    {
        llSetLinkColor(gDicePrim0,<0.4,0.4,0.4>,ALL_SIDES);
        llSetLinkColor(gDicePrim1,<0.4,0.4,0.4>,ALL_SIDES);

        if (gTotalScore >= gScoreToBeat)
        {
            llWhisper(0, llKey2Name(gCurrentPlayer) + " has went out with a score of " + (string)gTotalScore);
            final = TRUE;
            gScoreToBeat = gTotalScore;
            high_score_player = gCurrentPlayer;

            next_player();
            if (gGameOver)
                return;

            llWhisper(0, "It is now " + llKey2Name(gCurrentPlayer) + "'s turn! Score to beat is " + (string)gScoreToBeat);

            if (gStarCount == 2)
                llWhisper(0, llKey2Name(gCurrentPlayer) + " you have two stars be careful.");
llPlaySound("f727ee90-cfe0-44b1-a0ce-95f0cab38daa",1.0);


            if (final)
                showScore(to_win, (gScoreToBeat - gTotalScore));
        }
        else
        {
            next_player();
            if (gGameOver)
                return;

            if (final)
                showScore(to_win, (gScoreToBeat - gTotalScore));

            if (gStarCount == 2)
                llWhisper(0, llKey2Name(gCurrentPlayer) + " you have two stars be careful.");


            llWhisper(0, "It is now " + llKey2Name(gCurrentPlayer) + "'s turn!");
        }
    }

    touch_end(integer x)
    {
        if (gGameOver)
            return;

        key user = llDetectedKey(0);
        integer link = llDetectedLinkNumber(0);
        integer face = llDetectedTouchFace(0);

        if (user == gCurrentPlayer)
        {
            if (link == options_prim)
            {
                if (face == 2)
                {
                    llSetLinkColor(gDicePrim0,<1,1,1>,ALL_SIDES);
                    llSetLinkColor(gDicePrim1,<1,1,1>,ALL_SIDES);
                    state round;
                }
                else if (face == 4)
                {
                    player_turn++;
                    next_player();
                }
            }
        }
    }

    link_message(integer l, integer n, string m, key id)
    {
        if (n == 1000)
        {
            if (m == "1001")
            {
                p1 = id;
                p1_name = llKey2Name(p1);
            }
            else if (m == "1002")
            {
                p2 = id;
                p2_name = llKey2Name(p2);
            }
            else if (m == "1003")
            {
                p3 = id;
                p3_name = llKey2Name(p3);
            }
            else if (m == "1004")
            {
                p4 = id;
                p4_name = llKey2Name(p4);
            }
            else if (m == "1005")
            {
                p5 = id;
                p5_name = llKey2Name(p5);
            }
            else if (m == "1006")
            {
                p6 = id;
                p6_name = llKey2Name(p6);
            }
            else if (m == "1007")
            {
                p7 = id;
                p7_name = llKey2Name(p7);
            }
            else if (m == "1008")
            {
                p8 = id;
                p8_name = llKey2Name(p8);
            }

            player_count++;
            llWhisper(0, "Welcome to the game, " + llKey2Name(id));
        }
        else if (n == 1001)
        {
            llWhisper(0, p1_name + " has left the game.");
            if (gCurrentPlayer == p1)
            {
                p1 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p1 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1002)
        {
            llWhisper(0, p2_name + " has left the game.");
            if (gCurrentPlayer == p2)
            {
                p2 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p2 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1003)
        {
            llWhisper(0, p3_name + " has left the game.");
            if (gCurrentPlayer == p3)
            {
                p3 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p3 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1004)
        {
            llWhisper(0, p4_name + " has left the game.");
            if (gCurrentPlayer == p4)
            {
                p4 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p4 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1005)
        {
            llWhisper(0, p5_name + " has left the game.");
            if (gCurrentPlayer == p5)
            {
                p5 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p5 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1006)
        {
            llWhisper(0, p6_name + " has left the game.");
            if (gCurrentPlayer == p6)
            {
                p6 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p6 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1007)
        {
            llWhisper(0, p7_name + " has left the game.");
            if (gCurrentPlayer == p7)
            {
                p7 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p7 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1008)
        {
            llWhisper(0, p8_name + " has left the game.");
            if (gCurrentPlayer == p8)
            {
                p8 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p8 = NULL_KEY;
                player_count--;
            }
        }
    }
}

state round
{
    state_entry()
    {
        player_turn++;
        gRoundScore = 0;
        showScore(points_prim, gRoundScore);
        gRoundOver = FALSE;
        gSafeNumber = -1;
        gRoundTimeElapsed = 0;
        gCurrentDice = [-1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED];
        rollDice();
        llSetTimerEvent(1.0);
    }

    timer()
    {
        gRoundTimeElapsed++;

        if (gRoundTimeElapsed == gRoundTime)
        {
            state playing;
        }
    }

    touch_end(integer _detected)
    {
        if (_detected != 1 || llDetectedKey(0) != gCurrentPlayer)
        {
           /|/ llWhisper(0,"Only the current player can touch the board");
            llPlaySound("2974fe06-718a-4ac6-81df-1ca3f96f3b49",1.0);
        }
        else
        {
            integer linkIndex = llDetectedLinkNumber(0);
            integer face = llDetectedTouchFace(0);

            if (gRoundOver == FALSE)
            {
                /|/ llOwnerSay("Touched " + (string)linkIndex);

                if (linkIndex == options_prim)
                {
                    if (face == 4)/|/ STOP
                    {
                        integer rollScore = scoreDice(STATE_CHOSEN, TRUE, FALSE);

                        if (rollScore == -1)
                        {
                            llInstantMessage(gCurrentPlayer,"Choose none or those with point value");
                        }
                        else if (gTotalScore < 1000 && (rollScore + gRoundScore) < 1000)
                        {
                            llWhisper(0, "You must have 1000 points to get on the board!");
                        }
                        else
                        {
                            gRoundScore += rollScore;
                            showScore(points_prim, gRoundScore);
                            gTotalScore += gRoundScore;
                            gStarCount = 0;
                            do_score(gTotalScore, gStarCount);

                            /|/ DO SCORING HERE
                            integer i = 0;

                            for (;i<6;++i)
                            {
                                if (llList2Integer(gCurrentDice,2*i+1)==STATE_CHOSEN)
                                {
                                    gCurrentDice = llListReplaceList(gCurrentDice,[STATE_SET],2*i+1,2*i+1);
                                    setColor(i);
                                }
                            }

                            gRoundOver = TRUE;
                            state playing;
                        }
                    }
                    else if (face == 2)
                    {
                        /|/    /|/ Figure out what score the player would get
                        integer tempSafe = gSafeNumber;
                        integer rollScore = scoreDice(STATE_CHOSEN, TRUE, TRUE);

                        /|/ If none and neither is a safe card used, deny the roll
                        if (rollScore == -1 || llListFindList(gCurrentDice,[STATE_CHOSEN]) == -1)
                        {
                            llWhisper(0, "Only select dice of point value");
                            llPlaySound("3bbaffae-8fde-4fe9-9c6f-f5fe3961bf05",1.0);
                            gSafeNumber = tempSafe;
                        }
                        /|/ Else valid selection
                        else
                        {
                            /|/ Increase the round score
                            gRoundScore += rollScore;
                            showScore(points_prim, gRoundScore);
                            show_scores();
                            /|/ DO SCORING HERE

                            /|/ Turn all selected ones blue and count # of them
                            integer chosenCount = 0;
                            integer i = 0;

                            for (;i<6;++i)
                            {
                                if (llList2Integer(gCurrentDice,2*i+1)==STATE_CHOSEN)
                                {
                                    gCurrentDice = llListReplaceList(gCurrentDice,[STATE_SET],2*i+1,2*i+1);
                                    setColor(i);
                                    chosenCount++;
                                }
                            }

                            /|/ Board cleared in this roll
                            if (chosenCount == 6)
                            {
                                gCurrentDice = [-1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED];
                                gSafeNumber = -1;
                            }
                            /|/ Board cleared. Start new round
                            if (llListFindList(gCurrentDice,[STATE_UNUSED]) == -1)
                            {
                                gCurrentDice = [-1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED];
                                gSafeNumber = -1;
                            }
                            /|/ Roll dice if all cleared or more left to roll
                            rollDice();
                        }
                    }
                }

                if (linkIndex == gDicePrim0 || linkIndex == gDicePrim1)
                {
                    integer faceIndex = llDetectedTouchFace(0);

                    if (llListFindList(FACES,[faceIndex]) != -1)
                    {
                        integer diceNumber = llListFindList(FACES,[faceIndex]);
                        if (linkIndex == gDicePrim1) diceNumber += 3;
                        integer diceState = llList2Integer(gCurrentDice,2*diceNumber+1);
                        if (diceState == STATE_UNUSED)
                        {
                            gCurrentDice = llListReplaceList(gCurrentDice,[STATE_CHOSEN],2*diceNumber+1,2*diceNumber+1);
                            setColor(diceNumber);
                        }
                        else if (diceState == STATE_CHOSEN)
                        {
                            gCurrentDice = llListReplaceList(gCurrentDice,[STATE_UNUSED],2*diceNumber+1,2*diceNumber+1);
                            setColor(diceNumber);
                        }
                    }
                }
            }
            else
            {
                llWhisper(0, "Wait for your turn!");
            }
        }
    }

    link_message(integer l, integer n, string m, key id)
    {
        if (n == 1000)
        {
            if (m == "1001")
            {
                p1 = id;
                p1_name = llKey2Name(p1);
            }
            else if (m == "1002")
            {
                p2 = id;
                p2_name = llKey2Name(p2);
            }
            else if (m == "1003")
            {
                p3 = id;
                p3_name = llKey2Name(p3);
            }
            else if (m == "1004")
            {
                p4 = id;
                p4_name = llKey2Name(p4);
            }
            else if (m == "1005")
            {
                p5 = id;
                p5_name = llKey2Name(p5);
            }
            else if (m == "1006")
            {
                p6 = id;
                p6_name = llKey2Name(p6);
            }
            else if (m == "1007")
            {
                p7 = id;
                p7_name = llKey2Name(p7);
            }
            else if (m == "1008")
            {
                p8 = id;
                p8_name = llKey2Name(p8);
            }

            player_count++;
            llWhisper(0, llKey2Name(id) + " has joined the game!");
        }
        else if (n == 1001)
        {
            llWhisper(0, p1_name + " has left the game.");
            if (gCurrentPlayer == p1)
            {
                p1 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p1 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1002)
        {
            llWhisper(0, p2_name + " has left the game.");
            if (gCurrentPlayer == p2)
            {
                p2 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p2 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1003)
        {
            llWhisper(0, p3_name + " has left the game.");
            if (gCurrentPlayer == p3)
            {
                p3 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p3 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1004)
        {
            llWhisper(0, p4_name + " has left the game.");
            if (gCurrentPlayer == p4)
            {
                p4 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p4 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1005)
        {
            llWhisper(0, p5_name + " has left the game.");
            if (gCurrentPlayer == p5)
            {
                p5 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p5 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1006)
        {
            llWhisper(0, p6_name + " has left the game.");
            if (gCurrentPlayer == p6)
            {
                p6 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p6 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1007)
        {
            llWhisper(0, p7_name + " has left the game.");
            if (gCurrentPlayer == p7)
            {
                p7 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p7 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1008)
        {
            llWhisper(0, p8_name + " has left the game.");
            if (gCurrentPlayer == p8)
            {
                p8 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p8 = NULL_KEY;
                player_count--;
            }
        }
    }
}
*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Releasex64 5.1.7.55786 - Jimmy Olsen
//last_compiled 11/24/2018 20:12:34
//mono




key p1 = NULL_KEY;
key p2 = NULL_KEY;
key p3 = NULL_KEY;
key p4 = NULL_KEY;
key p5 = NULL_KEY;
key p6 = NULL_KEY;
key p7 = NULL_KEY;
key p8 = NULL_KEY;

string p1_name;
string p2_name;
string p3_name;
string p4_name;
string p5_name;
string p6_name;
string p7_name;
string p8_name;

integer p1_stars;
integer p2_stars;
integer p3_stars;
integer p4_stars;
integer p5_stars;
integer p6_stars;
integer p7_stars;
integer p8_stars;

integer p1_score;
integer p2_score;
integer p3_score;
integer p4_score;
integer p5_score;
integer p6_score;
integer p7_score;
integer p8_score;
integer player_count;
integer player_turn;
integer current_id;

integer p1_id;
integer p2_id;
integer p3_id;
integer p4_id;
integer p5_id;
integer p6_id;
integer p7_id;
integer p8_id;


list FACES = [4,0,2];
list ROTS = [90,0,270];

key TEXTURE = "012eaa6f-fed9-4c13-ab3a-28f426113857";


integer STATE_UNUSED = 2002000; 
integer STATE_CHOSEN = 2002001; 
integer STATE_SET = 2002002;
integer TEXTURE_DICE_OFFSET = 1;




integer gScoreToBeat = 10000;
float gVolume = 1.0;
integer gRoundTime = 120;

key high_score_player = NULL_KEY;
key gCurrentPlayer = NULL_KEY;  
integer gTotalScore;            
integer gGameOver = FALSE;


integer gRoundTimeElapsed;
integer gRoundScore;
integer gStarCount;
list gCurrentDice;  
integer gRoundOver = FALSE;
integer gSafeNumber;    
integer final = FALSE;


integer gDicePrim0;
integer gDicePrim1;
integer main;
integer points_prim;
integer options_prim;
integer to_win;
key diceroll         = "d163a741-5bd3-40c1-b950-2a277debb2f3";
key player_won       = "48bef746-09cd-4f4e-9df3-8e26b46a8794";
key next_turn        = "ad62678d-6c9a-4640-8d65-a568a35d25bc";

key theNumbers = "fc8f3317-9f84-4e7d-b9fc-919f09da8e10";
key theTrans   = "8dcd4a48-2d37-4909-9f78-f7a9eb4ef903";




integer random_integer( integer min, integer max )
{
    return min + (integer)( llFrand( max - min + 1 ) );
}

integer getLinkDescStars(integer LINK)
{
    list params = llGetLinkPrimitiveParams(LINK, [PRIM_DESC]);
    list data = llCSV2List(llList2String(params, 0));
    return llList2Integer(data, 1);
}

integer getLinkDescScore(integer LINK)
{
    list params = llGetLinkPrimitiveParams(LINK, [PRIM_DESC]);
    list data = llCSV2List(llList2String(params, 0));
    return llList2Integer(data, 0);
}

game_over()
{
    if (gGameOver)
      return;
      llParticleSystem(
                [
                    PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_EXPLODE,
                    PSYS_SRC_BURST_RADIUS,1.1,
                    PSYS_SRC_ANGLE_BEGIN,0,
                    PSYS_SRC_ANGLE_END,0,
                    PSYS_SRC_TARGET_KEY,llGetKey(),
                    PSYS_PART_START_COLOR,<1.000000,1.000000,1.000000>,
                    PSYS_PART_END_COLOR,<1.000000,1.000000,1.000000>,
                    PSYS_PART_START_ALPHA,1,
                    PSYS_PART_END_ALPHA,1,
                    PSYS_PART_START_GLOW,0.5,
                    PSYS_PART_END_GLOW,0.5,
                    PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
                    PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
                    PSYS_PART_START_SCALE,<0.100000,0.100000,0.100000>,
                    PSYS_PART_END_SCALE,<0.300000,0.300000,0.300000>,
                    PSYS_SRC_TEXTURE,"9453a1b6-0a64-4e03-a89e-047705fc56ef",
                    PSYS_SRC_MAX_AGE,3,
                    PSYS_PART_MAX_AGE,5,
                    PSYS_SRC_BURST_RATE,0.1,
                    PSYS_SRC_BURST_PART_COUNT,51,
                    PSYS_SRC_ACCEL,<0.000000,0.000000,-0.600000>,
                    PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
                    PSYS_SRC_BURST_SPEED_MIN,1.2,
                    PSYS_SRC_BURST_SPEED_MAX,2,
                    PSYS_PART_FLAGS,
                        0 |
                        PSYS_PART_BOUNCE_MASK |
                        PSYS_PART_FOLLOW_VELOCITY_MASK
                ]);
                
                llSleep(4);
                
                llParticleSystem([]);

    if (player_count <= 0)
    {
        llWhisper(0, "All players left, game resetting.");
    }
    else if (high_score_player)
    {
        llTriggerSound(player_won, gVolume);
        llWhisper(0, "Congrats " + llKey2Name(high_score_player) + " you have just won the game.");
    }
     





















    gGameOver = TRUE;
    llMessageLinked(LINK_SET, 4444, "", "");
}

textureAll(integer _texture)
{
    integer i = 0;
    for (;i < 6; ++i)
        setDiceTexture(i,_texture);
}

string star_convert(integer stars)
{
    string s;

    if (stars == 1)
        s = "*";
    else if (stars == 2)
        s = "**";

    return s;
}

show_scores()
{
    if (p1)
        llSetLinkPrimitiveParamsFast(p1_id, [ PRIM_TEXT, llKey2Name(p1) + star_convert(p1_stars) +"\n"+ (string)p1_score, <1,1,1>, 1.0] );
    if (p2)
        llSetLinkPrimitiveParamsFast(p2_id, [ PRIM_TEXT, llKey2Name(p2) + star_convert(p2_stars) +"\n"+ (string)p2_score, <1,1,1>, 1.0] );
    if (p3)
        llSetLinkPrimitiveParamsFast(p3_id, [ PRIM_TEXT, llKey2Name(p3) + star_convert(p3_stars) +"\n"+ (string)p3_score, <1,1,1>, 1.0] );
    if (p4)
        llSetLinkPrimitiveParamsFast(p4_id, [ PRIM_TEXT, llKey2Name(p4) + star_convert(p4_stars) +"\n"+ (string)p4_score, <1,1,1>, 1.0] );
    if (p5)
        llSetLinkPrimitiveParamsFast(p5_id, [ PRIM_TEXT, llKey2Name(p5) + star_convert(p5_stars) +"\n"+ (string)p5_score, <1,1,1>, 1.0] );
    if (p6)
        llSetLinkPrimitiveParamsFast(p6_id, [ PRIM_TEXT, llKey2Name(p6) + star_convert(p6_stars) +"\n"+ (string)p6_score, <1,1,1>, 1.0] );
    if (p7)
        llSetLinkPrimitiveParamsFast(p7_id, [ PRIM_TEXT, llKey2Name(p7) + star_convert(p7_stars) +"\n"+ (string)p7_score, <1,1,1>, 1.0] );
    if (p8)
        llSetLinkPrimitiveParamsFast(p8_id, [ PRIM_TEXT, llKey2Name(p8) + star_convert(p8_stars) +"\n"+ (string)p8_score, <1,1,1>, 1.0] );

    
    if (p1 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p1_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p2 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p2_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p3 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p3_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p4 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p4_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p5 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p5_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p6 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p6_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p7 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p7_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
    if (p8 == NULL_KEY)
        llSetLinkPrimitiveParamsFast(p8_id, [ PRIM_TEXT, " ", <0,1,0>, 1.0] );
}

showScore(integer link, integer score)
{
    if (score==-1)
    {
        llSetLinkPrimitiveParamsFast(link, [PRIM_TEXTURE, 1, theNumbers, <0.17, 1., 1.>, <0.405, 0., 0.>, 0.,
                PRIM_TEXTURE, 6, theNumbers, <0.068, 1., 1.>, <0.388, 0., 0.>, 0.,
                PRIM_TEXTURE, 4, theNumbers, <-1.122, 1., 1.>, <0.851, 0., 0.>, 0.,
                PRIM_TEXTURE, 7, theNumbers, <0.068, 1., 1.>, <0.265, 0., 0.>, 0.,
                PRIM_TEXTURE, 3, theNumbers, <0.17, 1., 1.>, <0.243, 0., 0.>, 0.]);
    }
    else
    {
        integer v1=score%10;
        integer v2=(score/10)%10;
        integer v3=(score/100)%10;
        integer v4=(score/1000)%10;
        integer v5=(score/10000)%10;
        key texture1 = theNumbers;
        key texture2 = theNumbers;
        key texture3 = theNumbers;
        key texture4 = theNumbers;
        key texture5 = theNumbers;
        if (score <10)
            texture2=theTrans;
        if (score <100)
            texture3=theTrans;
        if (score <1000)
            texture4=theTrans;
        if (score <10000)
            texture5=theTrans;
        llSetLinkPrimitiveParamsFast(link, [PRIM_TEXTURE, 1, texture1, <0.17, 1., 1.>, <-0.521 + 0.0642222 * v1, 0., 0.>, 0.,
                PRIM_TEXTURE, 6, texture2, <0.068, 1., 1.>, <-0.4657 + 0.0642222 * v2, 0., 0.>, 0.,
                PRIM_TEXTURE, 4, texture3, <-1.122, 1., 1.>, <-0.941 + 0.0642222 * v3, 0., 0.>, 0.,
                PRIM_TEXTURE, 7, texture4, <0.068, 1., 1.>, <-0.4567 + 0.0642222 * v4, 0., 0.>, 0.,
                PRIM_TEXTURE, 3, texture5, <0.17, 1., 1.>, <-0.416 + 0.0642222 * v5, 0., 0.>, 0.]);
    }
}

integer setTexture(integer _linkNumber, integer _face, integer _textureNumber)
{
    llSetLinkPrimitiveParamsFast(_linkNumber,[PRIM_TEXTURE,llList2Integer(FACES,_face),TEXTURE, <0.25,0.25,0.0>, <-.375+0.25*(_textureNumber%4), 0.375-0.25*(_textureNumber/4), 0.0>, llList2Integer(ROTS,_face)*DEG_TO_RAD]);
    return 1;
}

setScore(integer link, integer score, integer stars)
{
    llSetLinkPrimitiveParamsFast(link, [PRIM_DESC, (string)score +","+ (string)stars]);
}

setDiceTexture(integer _diceNumber, integer _texture)
{
    if (_diceNumber < 3) setTexture(gDicePrim0,_diceNumber,_texture);
    else setTexture(gDicePrim1,_diceNumber-3,_texture);
}

setColor(integer _diceNumber)
{
    integer diceState = llList2Integer(gCurrentDice,_diceNumber*2+1);
    integer dicePrim = gDicePrim0;
    if (_diceNumber > 2)
    {
        _diceNumber -= 3;
        dicePrim = gDicePrim1;
    }

    vector diceColor;
    if (diceState == STATE_UNUSED) diceColor = <1,1,1>;
    else if (diceState == STATE_CHOSEN) diceColor = <0.4,0.4,0.4>;
    else if (diceState == STATE_SET) diceColor = <0.4,0.0,0.0>;
    llSetLinkColor(dicePrim,diceColor,llList2Integer(FACES,_diceNumber));
}

integer scoreDice(integer _state, integer _strict, integer _newSafe)
{
    list selected = [];
    integer i = 0;
    for (;i<6;++i)
    {
        if (llList2Integer(gCurrentDice,i*2+1) == _state)
            selected += llList2Integer(gCurrentDice,i*2);
    }

    list temp = llListSort(selected,1,TRUE);

    integer totalDice = llGetListLength(temp);
    integer usedDice = 0;
    integer safeNumberCandidate = -1;

    integer fiveused = FALSE;
    integer oneused = FALSE;
    integer totalRoll = 0;


    integer pairCount = 0;
    if (llGetListLength(temp) == 6)
    {
        

        integer j = 1;
        for (;j<=6;++j)
        {
            if (~llListFindList(temp,[j,j])) pairCount++;
        }
    }
    if (pairCount == 3)
    {
        totalRoll += 1500;
        usedDice = 6;
    }

    else if (~llListFindList(temp,[1,2,3,4,5,6]))    {
        totalRoll += 1500; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,2,3,4,5,5]))    {
        totalRoll += 1050; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,2,3,4,5]))    {
        totalRoll += 1100; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,2,3,4,5]))    {
        totalRoll += 1000; 
        usedDice = 5;
         }

    else if (~llListFindList(temp,[2,3,4,5,5,6]))    {
        totalRoll += 1050; 
        usedDice = 6;
        
        
        }
        

    else if (~llListFindList(temp,[2,3,4,5,6]))    {
        totalRoll += 1000; 
        usedDice = 5;
       
        }

    else if (~llListFindList(temp,[1,1,1,1,2,2]))    {
        totalRoll += 2500; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,1,3,3]))    {
        totalRoll += 2500; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,1,4,4]))    {
        totalRoll += 2500; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,1,5,5]))    {
        totalRoll += 2500; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,1,6,6]))    {
        totalRoll += 2500; 
        usedDice = 6;
        
        }

    else if (~llListFindList(temp,[1,1,2,2,2,2]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,2,3,3]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,2,4,4]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,2,5,5]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,2,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,3,3,3,3]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,3,3,3,3]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,3,3,4,4]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,3,3,5,5]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,3,3,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,4,4,4,4]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,4,4,4,4]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,4,4,4,4]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[4,4,4,4,5,5]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[4,4,4,4,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,5,5,5,5]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,5,5,5,5]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,5,5,5,5]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[4,4,5,5,5,5]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[5,5,5,5,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,6,6,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,6,6,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,6,6,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[4,4,6,6,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[5,5,6,6,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,2,2,2]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,3,3,3]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,4,4,4]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,5,5,5]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[1,1,1,6,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,3,3,3]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,4,4,4]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,5,5,5]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[2,2,2,6,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,3,4,4,4]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,3,5,5,5]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[3,3,3,6,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[4,4,4,5,5,5]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[4,4,4,6,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
        }

    else if (~llListFindList(temp,[5,5,5,6,6,6]))    {
        totalRoll += 2000; 
        usedDice = 6;
    }
    
    else if (~llListFindList(temp,[1,1,1,1,1,1]))   {
        totalRoll += 8000;
        usedDice = 6;
        llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
        
    }
    else if (~llListFindList(temp,[2,2,2,2,2,2]))   {
        totalRoll += 1600;
        usedDice = 6;
        llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
    }
    else if (~llListFindList(temp,[3,3,3,3,3,3]))   {
        totalRoll += 2400;
        usedDice = 6;
        llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
    }
    else if (~llListFindList(temp,[4,4,4,4,4,4]))   {
        totalRoll += 3200;
        usedDice = 6;
        llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
    }
    else if (~llListFindList(temp,[5,5,5,5,5,5]))   {
        totalRoll += 4000;
        usedDice = 6;
        llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
    }
    else if (~llListFindList(temp,[6,6,6,6,6,6]))   {
        totalRoll += 4800;
        usedDice = 6;
        llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
    }
    else 
    {
        integer trySafe = TRUE;
        if (~llListFindList(temp,[1,1,1])) {
            oneused = TRUE;
            totalRoll += 1000;
            usedDice += 3;
            if (~llListFindList(temp,[1,1,1,1]))
            {
                oneused = TRUE;
                totalRoll += 1000;
                usedDice++;
                if (~llListFindList(temp,[1,1,1,1,1]))
                {
                    oneused = TRUE;
                    totalRoll += 2000;
                    usedDice++;
                    llPlaySound("b799b19c-b037-40ec-89c6-32e2dc4145e2",1.0);
                }
            }
        }

        if (~llListFindList(temp,[2,2,2]))
        {
            if (gSafeNumber == 2) trySafe= FALSE;
            totalRoll += 200;
            usedDice += 3;
            safeNumberCandidate = 2;
            if (~llListFindList(temp,[2,2,2,2]))
            {
                totalRoll += 200; 
                usedDice++;
                if (~llListFindList(temp,[2,2,2,2,2]))  {
                    totalRoll += 400; 
                    usedDice++;
                }
            }
        }

        if (~llListFindList(temp,[3,3,3]))
        {
            if (gSafeNumber == 3) trySafe = FALSE;
            totalRoll += 300;
            usedDice += 3;
            safeNumberCandidate = 3;
            if (~llListFindList(temp,[3,3,3,3]))
            {
                totalRoll += 300; 
                usedDice++;
                if (~llListFindList(temp,[3,3,3,3,3]))  {
                    totalRoll += 600; 
                    usedDice++;
                }
            }
        }

        if (~llListFindList(temp,[4,4,4]))
        {
            if (gSafeNumber == 4) trySafe = FALSE;
            totalRoll += 400;
            usedDice += 3;
            safeNumberCandidate = 4;
            if (~llListFindList(temp,[4,4,4,4]))
            {
                totalRoll += 400; 
                usedDice++;
                if (~llListFindList(temp,[4,4,4,4,4]))  {
                    totalRoll += 800; 
                    usedDice++;
                }
            }
        }

        if (~llListFindList(temp,[5,5,5]))
        {
            fiveused = TRUE;
            totalRoll += 500;
            usedDice += 3;
            if (~llListFindList(temp,[5,5,5,5]))
            {
                fiveused = TRUE;
                totalRoll += 500;
                usedDice++;
                if (~llListFindList(temp,[5,5,5,5,5]))
                {
                    fiveused = TRUE;
                    totalRoll += 1000;
                    usedDice++;
                }
            }
        }

        if (~llListFindList(temp,[6,6,6]))
        {
            if (gSafeNumber == 6) trySafe = FALSE;
            totalRoll += 600;
            usedDice += 3;
            safeNumberCandidate = 6;
            if (~llListFindList(temp,[6,6,6,6]))
            {
                totalRoll += 600; 
                usedDice++;
                if (~llListFindList(temp,[6,6,6,6,6]))  {
                    totalRoll += 1200; 
                    usedDice++;
                }
            }
        }

        if ((~llListFindList(temp,[5])) && !fiveused)
        {
            totalRoll += 50;
            usedDice++;
            if ((~llListFindList(temp,[5,5])) && !fiveused)   {
                totalRoll += 50;
                usedDice++;
            }
        }
        if ((~llListFindList(temp,[1])) && !oneused)
        {
            totalRoll += 100;
            usedDice++;
            if ((~llListFindList(temp,[1,1])) && !oneused)    {
                totalRoll += 100;
                usedDice++;
            }
        }
        
        if (trySafe == TRUE)    {
            if (~llListFindList(temp,[gSafeNumber])) {
                usedDice++;
                if (~llListFindList(temp,[gSafeNumber,gSafeNumber]))  {
                    usedDice++;
                }
            }
        }

    }
    if (_newSafe == TRUE && safeNumberCandidate != -1) gSafeNumber = safeNumberCandidate;
    if (_strict == TRUE && usedDice != totalDice) return -1;
    else return totalRoll;
}

rollDice()
{
    llPlaySound(diceroll, gVolume);

    
    
    integer i = 0;
    integer safeGenerated = FALSE;
    for (;i < 6; ++i)
    {
        integer dieState = llList2Integer(gCurrentDice,i*2+1);
        if (dieState == STATE_UNUSED)
        {
            
            integer texture = random_integer(1,6);
            if (texture == gSafeNumber) safeGenerated = TRUE;
            gCurrentDice = llListReplaceList(gCurrentDice,[texture],i*2,i*2);
            setDiceTexture(i, texture + TEXTURE_DICE_OFFSET - 1);
            setColor(i);
        }
    }

    
    if (scoreDice(STATE_UNUSED, FALSE, FALSE) == 0 && safeGenerated == FALSE)
    {
        gStarCount++;
        
        
        gRoundScore = 0;
        gRoundOver = TRUE;
        
        llSetLinkColor(gDicePrim0,<0.4,0,0>,ALL_SIDES);
        llSetLinkColor(gDicePrim1,<0.4,0,0>,ALL_SIDES);
        

        if (gStarCount == 3)
        {
            llWhisper(0, "3 Stars. Lost all points");
            gTotalScore = 0;
            gStarCount = 0;
            llPlaySound("ae56373a-70da-411b-9b14-2ba118cac702",1.0);
            
        }

        llSleep(0.5);
        do_score(gTotalScore, gStarCount);
        show_scores();
        
        state playing;
    }
}

next_player()
{
    if (gGameOver)
      return;

    llSetLinkColor(current_id, <1,0.7,0.5>, 2);
    llTriggerSound(next_turn, gVolume);
    
    gCurrentPlayer = NULL_KEY;
    gTotalScore = 0;
    gStarCount = 0;

    if (player_count <= 0)
    {
        game_over();
    }
    else
    {
        if (player_turn == 0 && p1 != NULL_KEY)
        {
            
            gCurrentPlayer = p1;
            current_id = p1_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p1_id);
            gStarCount = getLinkDescStars(p1_id);
        }

        if (player_turn == 1 && p2 != NULL_KEY)
        {
            
            gCurrentPlayer = p2;
            current_id = p2_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p2_id);
            gStarCount = getLinkDescStars(p2_id);
        }

        if (player_turn == 2 && p3 != NULL_KEY)
        {
            
            gCurrentPlayer = p3;
            current_id = p3_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p3_id);
            gStarCount = getLinkDescStars(p3_id);
        }

        if (player_turn == 3 && p4 != NULL_KEY)
        {
            
            gCurrentPlayer = p4;
            current_id = p4_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p4_id);
            gStarCount = getLinkDescStars(p4_id);
        }

        if (player_turn == 4 && p5 != NULL_KEY)
        {
            
            gCurrentPlayer = p5;
            current_id = p5_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p5_id);
            gStarCount = getLinkDescStars(p5_id);
        }

        if (player_turn == 5 && p6 != NULL_KEY)
        {
            
            gCurrentPlayer = p6;
            current_id = p6_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p6_id);
            gStarCount = getLinkDescStars(p6_id);
        }

        if (player_turn == 6 && p7 != NULL_KEY)
        {
            
            gCurrentPlayer = p7;
            current_id = p7_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p7_id);
            gStarCount = getLinkDescStars(p7_id);
        }

        if (player_turn == 7 && p8 != NULL_KEY)
        {
            
            gCurrentPlayer = p8;
            current_id = p8_id;
            llSetLinkColor(current_id, <0,1,0>, 2);
            gTotalScore = getLinkDescScore(p8_id);
            gStarCount = getLinkDescStars(p8_id);
        }

        if (gCurrentPlayer == NULL_KEY)
        {
            player_turn++;

            if(player_turn > 7)
                player_turn = 0;

            next_player();
        }

        

        if (gCurrentPlayer == high_score_player && final == TRUE)
        {
            game_over();
        }
    }
}

enumeratePrims()
{
    integer linkIndex = llGetNumberOfPrims();
    for (;linkIndex >= 1; --linkIndex)
    {
        string linkName = llGetLinkName(linkIndex);
        if (linkName == "D1") gDicePrim0 = linkIndex;
        else if (linkName == "D2") gDicePrim1 = linkIndex;
        else if (linkName == "center") main = linkIndex;  
        else if (linkName == "options") options_prim = linkIndex;
        else if (linkName == "to_win") to_win = linkIndex;
        else if (linkName == "points") points_prim = linkIndex;

        else if (linkName == "p1") p1_id = linkIndex;
        else if (linkName == "p2") p2_id = linkIndex;
        else if (linkName == "p3") p3_id = linkIndex;
        else if (linkName == "p4") p4_id = linkIndex;
        else if (linkName == "p5") p5_id = linkIndex;
        else if (linkName == "p6") p6_id = linkIndex;
        else if (linkName == "p7") p7_id = linkIndex;
        else if (linkName == "p8") p8_id = linkIndex;
    }
}

do_score(integer score, integer stars)
{
    if (gCurrentPlayer == p1)
    {
        p1_score = score;
        p1_stars = stars;
        setScore(p1_id, p1_score, p1_stars);
    }
    else if (gCurrentPlayer == p2)
    {
        p2_score = score;
        p2_stars = stars;
        setScore(p2_id, p2_score, p2_stars);
    }
    else if (gCurrentPlayer == p3)
    {
        p3_score = score;
        p3_stars = stars;
        setScore(p3_id, p3_score, p3_stars);
    }
    else if (gCurrentPlayer == p4)
    {
        p4_score = score;
        p4_stars = stars;
        setScore(p4_id, p4_score, p4_stars);
    }
    else if (gCurrentPlayer == p5)
    {
        p5_score = score;
        p5_stars = stars;
        setScore(p5_id, p5_score, p5_stars);
    }
    else if (gCurrentPlayer == p6)
    {
        p6_score = score;
        p6_stars = stars;
        setScore(p6_id, p6_score, p6_stars);
    }
    else if (gCurrentPlayer == p7)
    {
        p7_score = score;
        p7_stars = stars;
        setScore(p7_id, p7_score, p7_stars);
    }
    else if (gCurrentPlayer == p8)
    {
        p8_score = score;
        p8_stars = stars;
        setScore(p8_id, p8_score, p8_stars);
    }

    show_scores();
}

clear()
{
    llSetLinkColor(p1_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p2_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p3_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p4_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p5_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p6_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p7_id, <1,0.7,0.5>, 2);
    llSetLinkColor(p8_id, <1,0.7,0.5>, 2);

    setScore(p1_id, 0,0);
    setScore(p2_id, 0,0);
    setScore(p3_id, 0,0);
    setScore(p4_id, 0,0);
    setScore(p5_id, 0,0);
    setScore(p6_id, 0,0);
    setScore(p7_id, 0,0);
    setScore(p8_id, 0,0);
}





default
{
    on_rez(integer _param)
    {
        llResetScript();
    }

    state_entry()
    {
        llMessageLinked(LINK_SET, 5555, "", "");
        state ready;
    }
}

state ready
{
    on_rez(integer _param)
    {
        llResetScript();
    }

    state_entry()
    {
        enumeratePrims();
        clear();
        llSetLinkColor(gDicePrim0,<1,1,1>,ALL_SIDES);
        llSetLinkColor(gDicePrim1,<1,1,1>,ALL_SIDES);
        show_scores();
        textureAll(1);
        showScore(points_prim, 0);
        showScore(to_win, 0);
    }

    touch_end(integer d)
    {
        integer link = llDetectedLinkNumber(0);
        key user = llDetectedKey(0);
        integer face = llDetectedTouchFace(0);

        if (link == options_prim)
        {
            

            if (user == p1 || user == p2 || user == p3 || user == p4 || user == p5 || user == p6 || user == p7 || user == p8)
            {
                

                if (face == 2)
                    state playing;
            }
        }
    }

    link_message(integer l, integer n, string m, key id)
    {
        

        if (n == 1000)
        {
            if (m == "1001")
            {
                p1 = id;
                p1_name = llKey2Name(p1);
            }
            else if (m == "1002")
            {
                p2 = id;
                p2_name = llKey2Name(p2);
            }
            else if (m == "1003")
            {
                p3 = id;
                p3_name = llKey2Name(p3);
            }
            else if (m == "1004")
            {
                p4 = id;
                p4_name = llKey2Name(p4);
            }
            else if (m == "1005")
            {
                p5 = id;
                p5_name = llKey2Name(p5);
            }
            else if (m == "1006")
            {
                p6 = id;
                p6_name = llKey2Name(p6);
            }
            else if (m == "1007")
            {
                p7 = id;
                p7_name = llKey2Name(p7);
            }
            else if (m == "1008")
            {
                p8 = id;
                p8_name = llKey2Name(p8);
            }

            player_count++;
            llWhisper(0, "Welcome to the game, " + llKey2Name(id) + " press ROLL to start game when all players are ready.");
        }
        else if (n == 1001)
        {
            llWhisper(0, p1_name + " has left the game.");
            p1 = NULL_KEY;
            player_count--;
        }
        else if (n == 1002)
        {
            llWhisper(0, p2_name + " has left the game.");
            p2 = NULL_KEY;
            player_count--;
        }
        else if (n == 1003)
        {
            llWhisper(0, p3_name + " has left the game.");
            p3 = NULL_KEY;
            player_count--;
        }
        else if (n == 1004)
        {
            llWhisper(0, p4_name + " has left the game.");
            p4 = NULL_KEY;
            player_count--;
        }
        else if (n == 1005)
        {
            llWhisper(0, p5_name + " has left the game.");
            p5 = NULL_KEY;
            player_count--;
        }
        else if (n == 1006)
        {
            llWhisper(0, p6_name + " has left the game.");
            p6 = NULL_KEY;
            player_count--;
        }
        else if (n == 1007)
        {
            llWhisper(0, p7_name + " has left the game.");
            p7 = NULL_KEY;
            player_count--;
        }
        else if (n == 1008)
        {
            llWhisper(0, p8_name + " has left the game.");
            p8 = NULL_KEY;
            player_count--;
        }
    }
}

state playing
{
    on_rez(integer x)
    {
        llResetScript();
    }

    state_entry()
    {
        llSetLinkColor(gDicePrim0,<0.4,0.4,0.4>,ALL_SIDES);
        llSetLinkColor(gDicePrim1,<0.4,0.4,0.4>,ALL_SIDES);

        if (gTotalScore >= gScoreToBeat)
        {
            llWhisper(0, llKey2Name(gCurrentPlayer) + " has went out with a score of " + (string)gTotalScore);
            final = TRUE;
            gScoreToBeat = gTotalScore;
            high_score_player = gCurrentPlayer;

            next_player();
            if (gGameOver)
                return;

            llWhisper(0, "It is now " + llKey2Name(gCurrentPlayer) + "'s turn! Score to beat is " + (string)gScoreToBeat);

            if (gStarCount == 2)
                llWhisper(0, llKey2Name(gCurrentPlayer) + " you have two stars be careful.");
llPlaySound("f727ee90-cfe0-44b1-a0ce-95f0cab38daa",1.0);


            if (final)
                showScore(to_win, (gScoreToBeat - gTotalScore));
        }
        else
        {
            next_player();
            if (gGameOver)
                return;

            if (final)
                showScore(to_win, (gScoreToBeat - gTotalScore));

            if (gStarCount == 2)
                llWhisper(0, llKey2Name(gCurrentPlayer) + " you have two stars be careful.");


            llWhisper(0, "It is now " + llKey2Name(gCurrentPlayer) + "'s turn!");
        }
    }

    touch_end(integer x)
    {
        if (gGameOver)
            return;

        key user = llDetectedKey(0);
        integer link = llDetectedLinkNumber(0);
        integer face = llDetectedTouchFace(0);

        if (user == gCurrentPlayer)
        {
            if (link == options_prim)
            {
                if (face == 2)
                {
                    llSetLinkColor(gDicePrim0,<1,1,1>,ALL_SIDES);
                    llSetLinkColor(gDicePrim1,<1,1,1>,ALL_SIDES);
                    state round;
                }
                else if (face == 4)
                {
                    player_turn++;
                    next_player();
                }
            }
        }
    }

    link_message(integer l, integer n, string m, key id)
    {
        if (n == 1000)
        {
            if (m == "1001")
            {
                p1 = id;
                p1_name = llKey2Name(p1);
            }
            else if (m == "1002")
            {
                p2 = id;
                p2_name = llKey2Name(p2);
            }
            else if (m == "1003")
            {
                p3 = id;
                p3_name = llKey2Name(p3);
            }
            else if (m == "1004")
            {
                p4 = id;
                p4_name = llKey2Name(p4);
            }
            else if (m == "1005")
            {
                p5 = id;
                p5_name = llKey2Name(p5);
            }
            else if (m == "1006")
            {
                p6 = id;
                p6_name = llKey2Name(p6);
            }
            else if (m == "1007")
            {
                p7 = id;
                p7_name = llKey2Name(p7);
            }
            else if (m == "1008")
            {
                p8 = id;
                p8_name = llKey2Name(p8);
            }

            player_count++;
            llWhisper(0, "Welcome to the game, " + llKey2Name(id));
        }
        else if (n == 1001)
        {
            llWhisper(0, p1_name + " has left the game.");
            if (gCurrentPlayer == p1)
            {
                p1 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p1 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1002)
        {
            llWhisper(0, p2_name + " has left the game.");
            if (gCurrentPlayer == p2)
            {
                p2 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p2 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1003)
        {
            llWhisper(0, p3_name + " has left the game.");
            if (gCurrentPlayer == p3)
            {
                p3 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p3 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1004)
        {
            llWhisper(0, p4_name + " has left the game.");
            if (gCurrentPlayer == p4)
            {
                p4 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p4 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1005)
        {
            llWhisper(0, p5_name + " has left the game.");
            if (gCurrentPlayer == p5)
            {
                p5 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p5 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1006)
        {
            llWhisper(0, p6_name + " has left the game.");
            if (gCurrentPlayer == p6)
            {
                p6 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p6 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1007)
        {
            llWhisper(0, p7_name + " has left the game.");
            if (gCurrentPlayer == p7)
            {
                p7 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p7 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1008)
        {
            llWhisper(0, p8_name + " has left the game.");
            if (gCurrentPlayer == p8)
            {
                p8 = NULL_KEY;
                player_count--;
                next_player();
            }
            else
            {
                p8 = NULL_KEY;
                player_count--;
            }
        }
    }
}

state round
{
    state_entry()
    {
        player_turn++;
        gRoundScore = 0;
        showScore(points_prim, gRoundScore);
        gRoundOver = FALSE;
        gSafeNumber = -1;
        gRoundTimeElapsed = 0;
        gCurrentDice = [-1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED];
        rollDice();
        llSetTimerEvent(1.0);
    }

    timer()
    {
        gRoundTimeElapsed++;

        if (gRoundTimeElapsed == gRoundTime)
        {
            state playing;
        }
    }

    touch_end(integer _detected)
    {
        if (_detected != 1 || llDetectedKey(0) != gCurrentPlayer)
        {
           
            llPlaySound("2974fe06-718a-4ac6-81df-1ca3f96f3b49",1.0);
        }
        else
        {
            integer linkIndex = llDetectedLinkNumber(0);
            integer face = llDetectedTouchFace(0);

            if (gRoundOver == FALSE)
            {
                

                if (linkIndex == options_prim)
                {
                    if (face == 4)
                    {
                        integer rollScore = scoreDice(STATE_CHOSEN, TRUE, FALSE);

                        if (rollScore == -1)
                        {
                            llInstantMessage(gCurrentPlayer,"Choose none or those with point value");
                        }
                        else if (gTotalScore < 1000 && (rollScore + gRoundScore) < 1000)
                        {
                            llWhisper(0, "You must have 1000 points to get on the board!");
                        }
                        else
                        {
                            gRoundScore += rollScore;
                            showScore(points_prim, gRoundScore);
                            gTotalScore += gRoundScore;
                            gStarCount = 0;
                            do_score(gTotalScore, gStarCount);

                            
                            integer i = 0;

                            for (;i<6;++i)
                            {
                                if (llList2Integer(gCurrentDice,2*i+1)==STATE_CHOSEN)
                                {
                                    gCurrentDice = llListReplaceList(gCurrentDice,[STATE_SET],2*i+1,2*i+1);
                                    setColor(i);
                                }
                            }

                            gRoundOver = TRUE;
                            state playing;
                        }
                    }
                    else if (face == 2)
                    {
                        
                        integer tempSafe = gSafeNumber;
                        integer rollScore = scoreDice(STATE_CHOSEN, TRUE, TRUE);

                        
                        if (rollScore == -1 || llListFindList(gCurrentDice,[STATE_CHOSEN]) == -1)
                        {
                            llWhisper(0, "Only select dice of point value");
                            llPlaySound("3bbaffae-8fde-4fe9-9c6f-f5fe3961bf05",1.0);
                            gSafeNumber = tempSafe;
                        }
                        
                        else
                        {
                            
                            gRoundScore += rollScore;
                            showScore(points_prim, gRoundScore);
                            show_scores();
                            

                            
                            integer chosenCount = 0;
                            integer i = 0;

                            for (;i<6;++i)
                            {
                                if (llList2Integer(gCurrentDice,2*i+1)==STATE_CHOSEN)
                                {
                                    gCurrentDice = llListReplaceList(gCurrentDice,[STATE_SET],2*i+1,2*i+1);
                                    setColor(i);
                                    chosenCount++;
                                }
                            }

                            
                            if (chosenCount == 6)
                            {
                                gCurrentDice = [-1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED];
                                gSafeNumber = -1;
                            }
                            
                            if (llListFindList(gCurrentDice,[STATE_UNUSED]) == -1)
                            {
                                gCurrentDice = [-1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED, -1, STATE_UNUSED];
                                gSafeNumber = -1;
                            }
                            
                            rollDice();
                        }
                    }
                }

                if (linkIndex == gDicePrim0 || linkIndex == gDicePrim1)
                {
                    integer faceIndex = llDetectedTouchFace(0);

                    if (llListFindList(FACES,[faceIndex]) != -1)
                    {
                        integer diceNumber = llListFindList(FACES,[faceIndex]);
                        if (linkIndex == gDicePrim1) diceNumber += 3;
                        integer diceState = llList2Integer(gCurrentDice,2*diceNumber+1);
                        if (diceState == STATE_UNUSED)
                        {
                            gCurrentDice = llListReplaceList(gCurrentDice,[STATE_CHOSEN],2*diceNumber+1,2*diceNumber+1);
                            setColor(diceNumber);
                        }
                        else if (diceState == STATE_CHOSEN)
                        {
                            gCurrentDice = llListReplaceList(gCurrentDice,[STATE_UNUSED],2*diceNumber+1,2*diceNumber+1);
                            setColor(diceNumber);
                        }
                    }
                }
            }
            else
            {
                llWhisper(0, "Wait for your turn!");
            }
        }
    }

    link_message(integer l, integer n, string m, key id)
    {
        if (n == 1000)
        {
            if (m == "1001")
            {
                p1 = id;
                p1_name = llKey2Name(p1);
            }
            else if (m == "1002")
            {
                p2 = id;
                p2_name = llKey2Name(p2);
            }
            else if (m == "1003")
            {
                p3 = id;
                p3_name = llKey2Name(p3);
            }
            else if (m == "1004")
            {
                p4 = id;
                p4_name = llKey2Name(p4);
            }
            else if (m == "1005")
            {
                p5 = id;
                p5_name = llKey2Name(p5);
            }
            else if (m == "1006")
            {
                p6 = id;
                p6_name = llKey2Name(p6);
            }
            else if (m == "1007")
            {
                p7 = id;
                p7_name = llKey2Name(p7);
            }
            else if (m == "1008")
            {
                p8 = id;
                p8_name = llKey2Name(p8);
            }

            player_count++;
            llWhisper(0, llKey2Name(id) + " has joined the game!");
        }
        else if (n == 1001)
        {
            llWhisper(0, p1_name + " has left the game.");
            if (gCurrentPlayer == p1)
            {
                p1 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p1 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1002)
        {
            llWhisper(0, p2_name + " has left the game.");
            if (gCurrentPlayer == p2)
            {
                p2 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p2 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1003)
        {
            llWhisper(0, p3_name + " has left the game.");
            if (gCurrentPlayer == p3)
            {
                p3 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p3 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1004)
        {
            llWhisper(0, p4_name + " has left the game.");
            if (gCurrentPlayer == p4)
            {
                p4 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p4 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1005)
        {
            llWhisper(0, p5_name + " has left the game.");
            if (gCurrentPlayer == p5)
            {
                p5 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p5 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1006)
        {
            llWhisper(0, p6_name + " has left the game.");
            if (gCurrentPlayer == p6)
            {
                p6 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p6 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1007)
        {
            llWhisper(0, p7_name + " has left the game.");
            if (gCurrentPlayer == p7)
            {
                p7 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p7 = NULL_KEY;
                player_count--;
            }
        }
        else if (n == 1008)
        {
            llWhisper(0, p8_name + " has left the game.");
            if (gCurrentPlayer == p8)
            {
                p8 = NULL_KEY;
                player_count--;
                state playing;
            }
            else
            {
                p8 = NULL_KEY;
                player_count--;
            }
        }
    }
}

 