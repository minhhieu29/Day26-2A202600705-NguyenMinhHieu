# Script khởi động toàn bộ hạ tầng Multi-Agent Lab 26 trên Windows (Conda/Local Python)
# Hướng dẫn: Mở PowerShell tại thư mục dự án và chạy: .\start_all_windows.ps1

Write-Host "=== ĐANG KHỞI ĐỘNG HỆ THỐNG MULTI-AGENT LAB 26 ===" -ForegroundColor Cyan

# 1. Thiết lập biến môi trường
$env:PYTHONPATH = "."

# 2. Khởi động 3 A2A Specialist Agents trong các cửa sổ terminal mới
Write-Host "1. Khởi động search_agent trên cổng 8001..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "`$env:PYTHONPATH='.'; python -m uvicorn agents.search_agent.agent:a2a_app --host localhost --port 8001"

Write-Host "2. Khởi động database_agent trên cổng 8002..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "`$env:PYTHONPATH='.'; python -m uvicorn agents.database_agent.agent:a2a_app --host localhost --port 8002"

Write-Host "3. Khởi động synthesis_agent trên cổng 8003..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "`$env:PYTHONPATH='.'; python -m uvicorn agents.synthesis_agent.agent:a2a_app --host localhost --port 8003"

# 3. Đợi các server khởi động trong 3 giây
Write-Host "Đang chờ các A2A specialist khởi động..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# 4. Khởi động Orchestrator ADK Web UI
Write-Host "4. Khởi động Orchestrator ADK Web UI trên cổng 8000..." -ForegroundColor Green
$ADK_PATH = "$env:LOCALAPPDATA\Python\pythoncore-3.14-64\Scripts\adk.exe"

if (Test-Path $ADK_PATH) {
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "`$env:PYTHONPATH='.'; & '$ADK_PATH' web agents/orchestrator"
} else {
    Write-Host "Không tìm thấy adk.exe tại đường dẫn mặc định. Thử chạy lệnh trực tiếp từ PATH..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "`$env:PYTHONPATH='.'; adk web agents/orchestrator"
}

Write-Host "`n=== KHỞI ĐỘNG HOÀN TẤT ===" -ForegroundColor Cyan
Write-Host "Vui lòng mở trình duyệt và truy cập: http://localhost:8000" -ForegroundColor Magenta
Write-Host "Để dừng toàn bộ hệ thống, hãy đóng các cửa sổ PowerShell vừa được mở." -ForegroundColor Red
