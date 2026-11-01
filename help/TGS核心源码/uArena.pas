unit uArena;

interface

uses
   Classes, SysUtils, BasicObj, DefType, UserSDB, AUtil32, uManager,
   uMonster, AnsStringCls, uUser;

const

    WIN_SECOND = 15;
    ADDMASTER_OK = 0;
    ADDMASTER_ALREADY = -3;
    ADDMEMBER_OK = 0;
    ADDMEMBER_NOTREADY = -2;
    ADDMEMBER_ALREADY = -3;

type
   TArenaObject = class
   private
        ID : integer;
        MasterX : Integer;
        MasterY : Integer;
        X1 : Integer;
        Y1 : Integer;
        X2 : Integer;
        Y2 : Integer;
        MX : Array [0..8-1] of Word;
        MY : Array [0..8-1] of Word;
        OutX : Integer;
        OutY : Integer;
        MasterUser : TUser;
        DataList:TList;
        WaitPlayerList:TList;
        WaitArenaCount : Word;
        LastSecond : Integer;
        PassSecond : Integer;
        UpdateItemTick : Integer;
        MemberAmount : Integer;
   protected
   public
      constructor Create;
      destructor Destroy; override;

      procedure Initial (aUser : TUser);
      function AddMember (aUser : TUser) : Integer;
      function AddMaster (aUser : TUser) : Integer;
      procedure ReStartRound;
      procedure DeleteMember (pMemberName : String);
      procedure DeleteWaitMaster(pMasterName : String);
      procedure UpdateMasterAfter(aAfter : integer);
      procedure SendToAll (aMessage : String) ;

      procedure Update (CurTick: integer);
   end;

   TArenaObjList = class
   private
      DataList : TList;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      function LoadFromFile (aFileName : String) : Boolean;
      function AddMember (aArenaKey : Word; aUser : TUser) : Integer;
      function AddMaster (aUser : TUser) : Integer;
      function  SelectMaster (aName :String ; aUser:TUser) : Boolean;
      procedure DeleteMaster (aArenaKey : Word; pMasterName : String);
      procedure DeleteMember (aArenaKey : Word; pMemberName : String);
      function CheckArena(aArenaKey : Word):Boolean;
      procedure Update (CurTick : Integer);
   end;



var
   ArenaObjList : TArenaObjList;

implementation

uses
   svMain, svClass, SubUtil;


constructor TArenaObject.Create;
begin
    DataList := TList.Create;
    WaitPlayerList := TList.Create;
end;

destructor TArenaObject.Destroy;
begin
    MasterUser := nil;
    WaitPlayerList.Free;
    DataList.Free;
    inherited Destroy;
end;

procedure TArenaObject.Initial (aUser : TUser);
begin
    MasterUser := nil;
end;

function TArenaObject.AddMember (aUser : TUser): Integer;
begin
    Result := ADDMEMBER_OK;
    if aUser.CheckArena > 0 then begin
        Result := ADDMEMBER_ALREADY;
        Exit;
    end;
    if MasterUser = nil then begin
        Result := -2;
        Exit;
    end;
    if DataList.Count < MemberAmount then begin
        aUser.JoinArena(2,ID);
        DataList.Add(aUser);
        if DataList.Count = 1 then begin
            aUser.SMoveSpace(aUser.Name,'USER',1,X1,Y1);
        end else begin
            aUser.SMoveSpace(aUser.Name,'USER',1,X2,Y2);
        end;
        Result := ADDMEMBER_OK;
    end;
    if DataList.Count > 1 then begin
        PassSecond := 0;
    end;
end;

function TArenaObject.AddMaster (aUser : TUser) : Integer;
var aManager :TManager;
   dod : TCreateDynamicObjectData;
   aObjectName :String;
begin
    if aUser.CheckArena > 0 then begin
        Result := ADDMASTER_ALREADY;
        Exit;
    end;
    if WaitPlayerList.Count < 8 then begin
{        if MasterUser = nil then begin
            aUser.JoinArena(1,ID);
            MasterUser := aUser;
            MasterUser.SMoveSpace(MasterUser.Name,'USER',1,MasterX,MasterY);
            MasterUser.SSendTopMessage(MasterUser.Name + '正在比武招亲中(' + IntToStr(MasterX) +':'+ IntToStr(MasterY)+ ')……');
            Result := 0;
        end else begin
            aUser.JoinArena(1,ID);
            WaitPlayerList.Add(aUser);
            Result := WaitPlayerList.Count;
            Inc(WaitArenaCount);
        end;
    end else begin}
        aUser.JoinArena(1,ID);
        WaitPlayerList.Add(aUser);
        Result := WaitPlayerList.Count;
        case Result of
            1..4 : aObjectName := Conv('绿绣球');
            5..8 : aObjectName := Conv('红绣球');
        end;
        aManager := ManagerList.GetManagerByIndex(1);
        FillChar (dod, SizeOf (TCreateDynamicObjectData), 0);
        DynamicObjectClass.GetDynamicObjectData (aObjectName, dod.rBasicData);
        dod.rBasicData.rName := aUser.Name;
        dod.rServerId := aManager.ServerID;
        dod.rX[0] := MX[Result - 1];
        dod.rY[0] := MY[Result - 1];
        dod.rScript := MarryBallID;
        TDynamicObjectList (aManager.DynamicObjectList).AddDynamicObject (@dod);
        Inc(WaitArenaCount);
        result := ADDMASTER_OK;
    end;
end;

procedure TArenaObject.DeleteMember (pMemberName : String);
var i :integer;
    aMember : TUser;
begin
    for i := 0 to DataList.Count - 1 do begin
        aMember := DataList.Items[i];
        if aMember.Name = pMemberName then begin
            PassSecond := 0;
            DataList.Delete(i);
            if DataList.Count = 0 then begin
                RestartRound;
            end;
            Break;
        end;
    end;
end;

procedure TArenaObject.ReStartRound;
var i:integer;
    aMember : TUser;
begin
    if MasterUser <> nil then begin
        MasterUser.JoinArena(0,0); //取消TUser的擂台标记
    end;

    MasterUser := nil;
    for i := DataList.Count - 1 downto 0 do begin
        aMember := DataList.Items[i];
        aMember.JoinArena(0,0);
        aMember.SetPosition(OutX,OutY);
        DataList.Delete(i);
    end;
    LastSecond := 30;
    PassSecond := 0;
{    if WaitPlayerList.Count > 0 then begin
        MasterUser := WaitPlayerList.Items[0];
        MasterUser.SMoveSpace(MasterUser.Name,'USER',1,MasterX,MasterY);
        MasterUser.SSendTopMessage(MasterUser.Name + '正在比武招亲中(' + IntToStr(MasterX) +':'+ IntToStr(MasterY)+ ')……');
        WaitPlayerList.Delete(0);
    end;}
end;

procedure TArenaObject.SendToAll (aMessage : String);
begin

end;

procedure TArenaObject.UpdateMasterAfter(aAfter : integer);
var
    aUser : TUser;
    aManager :TManager;
    dObject : TDynamicObject;
    i : integer;
begin
    for i := aAfter to WaitPlayerList.Count - 1 do begin
        aUser := WaitPlayerList.Items[i];
        aManager := ManagerList.GetManagerByIndex(1);
        dObject := TDynamicObjectList (aManager.DynamicObjectList).GetDynamicObjectbyName(aUser.Name);
        UserList.SendHideDynamicObject(dObject.BasicData);
        dObject.BasicData.x := MX[i];
        dObject.BasicData.y := MY[i];
        UserList.SendShowDynamicObject(dObject.BasicData);
    end;
end;

procedure TArenaObject.DeleteWaitMaster(pMasterName : String);
var
    i: integer;
    aUser : TUser;
    aManager :TManager;
begin
    for i := 0 to WaitPlayerList.Count - 1 do begin
        aUser := WaitPlayerList.Items[i];
        if aUser.Name = pMasterName then Begin
          aUser.JoinArena(0,0);
          WaitPlayerList.Delete(i);
          Dec(WaitArenaCount);
          aManager := ManagerList.GetManagerByIndex(1);
          TDynamicObjectList (aManager.DynamicObjectList).DeleteDynamicObject(pMasterName);
          UpdateMasterAfter(i);
          Break;
        end;
    end;
end;


procedure TArenaObject.Update (CurTick: integer);
var i:integer;
    aUser : TUser;
    aItemData : TItemData;
begin
    if UpdateItemTick = 0 then UpdateItemTick := CurTick;
    if DataList.Count = 1 then begin
        if UpdateItemTick + 60 * 100 < CurTick then begin
            aUser := DataList.Items[0];
            Inc(PassSecond);
            aUser.SSendTopMessage(aUser.Name + Conv('已经') + IntToStr(PassSecond) + Conv('分钟无人应战！'));
            if PassSecond >= WIN_SECOND then begin
                aUser.SSendTopMessage(Conv('比武招亲结束，胜者:') + aUser.Name);
                aUser.SetPosition(OutX,OutY);
                if (aUser.Lover = '') and (MasterUser.Lover = '') then begin
                    aUser.Lover := MasterUser.Name;
                    MasterUser.Lover := aUser.Name;
                    ItemClass.GetItemData(Conv('喜帖'),aItemData);
                    aItemData.rCount := 10;
                    aUser.AddItem(aItemData);
                    MasterUser.AddItem(aItemData);
                    MarryList.AddMarry(aUser.Name,MasterUser.Name);
                    UserList.SendTopMessage(Conv('恭喜') + aUser.Name + Conv('和') + MasterUser.Name + Conv('喜良结缘'));
                end;
                ReStartRound;
            end;
            UpdateItemTick := CurTick;
        end;
    end;
    for i := DataList.Count-1 Downto 0 do begin
        aUser := DataList.Items[i];
        if aUser.GetLifeObjectState = los_die then begin
            aUser.SSendTopMessage(aUser.Name + Conv('被打败了。'));
            aUser.SetPosition(OutX,OutY);
            aUser.JoinArena(0,0);
            DataList.Delete(i);
        end;
    end;
end;

constructor TArenaObjList.Create;
begin
   DataList := TList.Create;
   LoadFromFile ('.\Init\Arena.SDB');
end;

destructor TArenaObjList.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy;
end;

procedure TArenaObjList.Clear;
begin
   DataList.Clear;
end;

function TArenaObjList.LoadFromFile (aFileName : String) : Boolean;
var
   i,j : Integer;
   iName : String;
   FileName : String;
   DB : TUserStringDB;
   aArena : TArenaObject;
begin
    if not FileExists (aFileName) then exit;

    Clear;

    DB := TUserStringDB.Create;
    DB.LoadFromFile (aFileName);
    for i := 0 to DB.Count - 1 do begin
        iName := DB.GetIndexName (i);
        if iName = '' then continue;
        aArena := TArenaObject.Create;
        aArena.ID := i;
        aArena.MasterX  := DB.GetFieldValueInteger (iName, 'MasterX');
        aArena.MasterY  := DB.GetFieldValueInteger (iName, 'MasterY');
        aArena.X1       := DB.GetFieldValueInteger (iName, 'X1');
        aArena.Y1       := DB.GetFieldValueInteger (iName, 'Y1');
        aArena.X2       := DB.GetFieldValueInteger (iName, 'X2');
        aArena.Y2       := DB.GetFieldValueInteger (iName, 'Y2');
        for j := 0 to 8 -1 do begin
            aArena.MX[j]    :=  DB.GetFieldValueInteger (iName, 'M' + IntToStr(j+1) + 'X');
            aArena.MY[j]    :=  DB.GetFieldValueInteger (iName, 'M' + IntToStr(j+1) + 'Y');
        end;
        aArena.MemberAmount := DB.GetFieldValueInteger (iName, 'MemberAmount');
        aArena.OutX := DB.GetFieldValueInteger (iName, 'OutX');
        aArena.OutY := DB.GetFieldValueInteger (iName, 'OutY');
        DataList.Add(aArena);
    end;
    DB.Free;

{
    aArena := TArenaObject.Create;
    aArena.ID := 1;
    aArena.MasterX  := 267;
    aArena.MasterY  := 881;
    aArena.X1       := 260;
    aArena.Y1       := 879;
    aArena.X2       := 257;
    aArena.Y2       := 882;
    aArena.MemberAmount := 2;
    DataList.Add(aArena);
}
end;

function TArenaObjList.SelectMaster (aName :String;aUser :TUser) : Boolean;
var
    aArena: TArenaObject;
    i,j,r : integer;
    aManager :TManager;
begin
    Result := False;
    for i := 0 to DataList.Count - 1 do begin
        aArena := DataList.Items[i];
        if aArena.MasterUser <> nil then Continue;
        for j := 0 to aArena.WaitPlayerList.Count - 1 do begin
            if TUser(aArena.WaitPlayerList.Items[j]).Name = aName then begin
                aArena.MasterUser := aArena.WaitPlayerList.Items[j];
                if aArena.AddMember(aUser) = ADDMEMBER_ALREADY then begin
                    aArena.MasterUser := nil;
                    Exit;
                end;
                aArena.MasterUser.inZhuang := True;
                aArena.MasterUser.SMoveSpace(aArena.MasterUser.Name,'USER',1,aArena.MasterX,aArena.MasterY);
                aArena.MasterUser.SSendTopMessage(aArena.MasterUser.Name + Conv('正在比武招亲中(') + IntToStr(aArena.MasterX) +':'+ IntToStr(aArena.MasterY)+ Conv(')……'));
                aArena.WaitPlayerList.Delete(j);
                Dec(aArena.WaitArenaCount);
                //删除相关dynamicobject
                aManager := ManagerList.GetManagerByIndex(1);
                TDynamicObjectList (aManager.DynamicObjectList).DeleteDynamicObject(aName);
                Result := True;
                Exit;
            end;
        end;
    end;
end;

function TArenaObjList.AddMaster (aUser : TUser) : Integer;
var
    aArena : TArenaObject;
    i : integer;
begin
    Result := -1;
    for i := 0 to DataList.Count - 1 do begin
        aArena := DataList.Items[i];
        if aArena.MasterUser = nil then begin
            if aArena.AddMaster(aUser) = ADDMASTER_OK then begin
                Result := i;
                Exit;
            end;
        end;
    end;

    for i := 0 to DataList.Count - 1 do begin
        aArena := DataList.Items[i];
        if aArena.WaitArenaCount < 8 then begin
            if aArena.AddMaster(aUser) = ADDMASTER_OK then begin
                Result := i;
                Break;
            end;
        end;
    end;
end;


function TArenaObjList.AddMember (aArenaKey : Word; aUser : TUser) : Integer;
var
    aArena : TArenaObject;
    i : integer;
begin
    Result := -1;
    if aArenaKey < DataList.Count then begin
        aArena := DataList.Items[aArenaKey];
        Result := aArena.AddMember(aUser);
    end;
end;

function TArenaObjList.CheckArena(aArenaKey : Word):Boolean;
var
    aArena : TArenaObject;
begin
    Result := False;
    if aArenaKey >= DataList.Count then begin
        Exit;
    end;
    aArena := DataList.Items[aArenaKey];
    if aArena.MasterUser = nil then
        Result := False
    else
        Result := True;
end;

procedure TArenaObjList.DeleteMaster (aArenaKey : Word; pMasterName : String);
var
    i :integer;
    aArena : TArenaObject;
begin
    if aArenaKey < DataList.Count then begin
        aArena := DataList.Items[aArenaKey];
        with aArena do begin
          if MasterUser <> nil then begin
            if MasterUser.Name = pMasterName then begin
                MasterUser.SSendTopMessage(pMasterName + Conv('退出了招亲擂台，该场结束'));
                ReStartRound;
                Exit;
            end;
          end;
          aArena.DeleteWaitMaster(pMasterName);
        end;
    end;
end;

procedure TArenaObjList.DeleteMember (aArenaKey : Word; pMemberName : String);
var
    aArena : TArenaObject;
    i: integer;
begin
    if aArenaKey < DataList.Count then begin
        aArena := DataList.Items[aArenaKey];
        aArena.DeleteMember(pMemberName);
    end;
end;

procedure TArenaObjList.Update (CurTick : Integer);
var i :integer;
    aArena : TArenaObject;
begin
    for i := 0 to DataList.Count - 1 do begin
        aArena := DataList.Items[i];
        aArena.Update(CurTick);
    end;
end;


end.
