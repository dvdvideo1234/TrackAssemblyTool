-- Using render library to draw points location
    if(self:GetPointAssist() == 0) then return end
      local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
      if(not trRec) then return end
      local ID, O = 1, Vector()
      while(ID <= trRec.Kept) do
        local stPOA = asmlib.LocatePOA(trRec,ID)
        if(not stPOA) then
          return asmlib.StatusLog(nil,"DrawHUD: Cannot assist point #"..tostring(ID)) end
        asmlib.SetVector(O,stPOA.O)
        O:Rotate(trEnt:GetAngles())
        O:Add(trEnt:GetPos()); ID = ID + 1
        cam.Start3D( LocalPlayer():EyePos(), LocalPlayer():EyeAngles() )
        goMonitor:DrawCircle(O, actrad, "as", "CAM3", {"color",50,50})
        cam.End3D()
      end; return