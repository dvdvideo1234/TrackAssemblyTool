-- Using render library to draw points location
    if(self:GetPointAssist() == 0) then return end
      local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
      if(not trRec) then return end
      local ID, O = 1, Vector()
      while(ID <= trRec.Size) do
        local stPOA = asmlib.LocatePOA(trRec,ID); if(not stPOA) then
          asmlib.LogInstance("DrawHUD: Cannot assist point #"..tostring(ID)) return nil end
        asmlib.SetVector(O,stPOA.O)
        O:Rotate(trEnt:GetAngles())
        O:Add(trEnt:GetPos()); ID = ID + 1
        cam.Start3D( LocalPlayer():EyePos(), LocalPlayer():EyeAngles() )
        goMonitor:DrawCircle(O, actrad, "as", "CAM3", {"color",50,50})
        cam.End3D()
      end; return
      
  cam.Start3D(ply:EyePos(), ply:EyeAngles())
  goMonitor:DrawCircle(O, actrad,"xx","CAM3",{"color",50,50})
  goMonitor:DrawLine  (O, O + R * 10,"r","CAM3",{true})
  goMonitor:DrawLine  (O, O - R * 10,"b","CAM3")
  cam.End3D()
