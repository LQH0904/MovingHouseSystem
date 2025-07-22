<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">

    </head>
    <body>

        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/admin/SideBar_Admin.jsp"></jsp:include> </div>
            <div class="div2">  <jsp:include page="/Layout/operator/Header.jsp"></jsp:include> </div>
                <div class="div3">
                <%-- Professional Admin Dashboard for div3 --%>
                <div class="professional-dashboard">
                    <!-- Dashboard Header -->
                    <div class="dashboard-header">
                        <div class="header-left">
                            <div class="header-icon">
                                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="2" y="3" width="20" height="14" rx="2" ry="2"/>
                                <line x1="8" y1="21" x2="16" y2="21"/>
                                <line x1="12" y1="17" x2="12" y2="21"/>
                                </svg>
                            </div>
                            <div class="header-text">
                                <h1>Giám sát hiệu suất Hệ Thống</h1>
                                
                            </div>
                        </div>
                        <div class="header-right">
                            <div class="status-badge online">
                                <div class="status-dot"></div>
                                <span>System Online</span>
                            </div>
                            <button class="refresh-button" onclick="refreshDashboard()">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="23 4 23 10 17 10"/>
                                <polyline points="1 20 1 14 7 14"/>
                                <path d="m3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/>
                                </svg>
                                Refresh
                            </button>
                        </div>
                    </div>

                    <!-- Key Metrics Cards -->
                    <div class="metrics-overview">
                        <div class="metric-card primary">
                            <div class="metric-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M9 19c-5 0-8-3-8-8s3-8 8-8 8 3 8 8-3 8-8 8"/>
                                <path d="M15 12h6"/>
                                </svg>
                            </div>
                            <div class="metric-content">
                                <div class="metric-value">${usedMemory} MB</div>
                                <div class="metric-label">Bộ nhớ đang dùng</div>
                                <div class="metric-change positive">
                                    <span class="change-indicator">↗</span>
                                    <span>${String.format("%.1f", (usedMemory * 100.0) / totalMemory)}%</span>
                                </div>
                            </div>
                            <div class="metric-chart">
                                <div class="progress-ring">
                                    <svg width="60" height="60">
                                    <circle cx="30" cy="30" r="25" fill="none" stroke="#e6f3ff" stroke-width="4"/>
                                    <circle cx="30" cy="30" r="25" fill="none" stroke="#4f46e5" stroke-width="4" 
                                            stroke-dasharray="157" stroke-dashoffset="${157 - (157 * usedMemory / totalMemory)}"
                                            transform="rotate(-90 30 30)"/>
                                    </svg>
                                    <div class="ring-text">${String.format("%.0f", (usedMemory * 100.0) / totalMemory)}%</div>
                                </div>
                            </div>
                        </div>

                        <div class="metric-card success">
                            <div class="metric-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                                <circle cx="9" cy="7" r="4"/>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                                </svg>
                            </div>
                            <div class="metric-content">
                                <div class="metric-value">${activeSessions}</div>
                                <div class="metric-label">Đang hoạt động</div>
                                <div class="metric-change positive">
                                    <span class="change-indicator">↗</span>
                                    <span>Online</span>
                                </div>
                            </div>
                            <div class="metric-trend">
                                <div class="trend-line">
                                    <div class="trend-point" style="left: 10%; height: 60%"></div>
                                    <div class="trend-point" style="left: 30%; height: 40%"></div>
                                    <div class="trend-point" style="left: 50%; height: 80%"></div>
                                    <div class="trend-point" style="left: 70%; height: 65%"></div>
                                    <div class="trend-point" style="left: 90%; height: 90%"></div>
                                </div>
                            </div>
                        </div>

                        <div class="metric-card warning">
                            <div class="metric-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/>
                                </svg>
                            </div>
                            <div class="metric-content">
                                <div class="metric-value">${requestCount}</div>
                                <div class="metric-label">Tổng lượt truy cập</div>
                                <div class="metric-change neutral">
                                    <span class="change-indicator">→</span>
                                    <span>${avgResponseTime}ms avg</span>
                                </div>
                            </div>
                            <div class="metric-sparkline">
                                <svg width="80" height="30" viewBox="0 0 80 30">
                                <polyline points="0,25 10,20 20,15 30,18 40,12 50,8 60,14 70,10 80,6" 
                                          fill="none" stroke="#f59e0b" stroke-width="2"/>
                                </svg>
                            </div>
                        </div>

                        <div class="metric-card info">
                            <div class="metric-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <ellipse cx="12" cy="5" rx="9" ry="3"/>
                                <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/>
                                <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
                                </svg>
                            </div>
                            <div class="metric-content">
                                <div class="metric-value">${totalQueries}</div>
                                <div class="metric-label">Hoạt động cơ sở dữ liệu</div>
                                <div class="metric-change positive">
                                    <span class="change-indicator">↗</span>
                                    <span>Executed</span>
                                </div>
                            </div>
                            <div class="metric-gauge">
                                <div class="gauge-fill" style="width: ${(totalQueries > 0) ? Math.min(totalQueries * 10, 100) : 0}%"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Detailed Analytics Section -->
                    <div class="analytics-section">
                        <!-- Memory Analysis -->
                        <div class="analytics-card memory-analysis">
                            <div class="card-header">
                                <h3>Phân tích bộ nhớ</h3>
                                <div class="card-actions">
                                    
                                </div>
                            </div>
                            <div class="card-content">
                                <div class="memory-breakdown">
                                    <div class="memory-item">
                                        <div class="memory-label">
                                            <div class="color-indicator used"></div>
                                            <span>Đã dùng </span>
                                        </div>
                                        <div class="memory-value">${usedMemory} MB</div>
                                        <div class="memory-bar">
                                            <div class="bar-fill used" style="width: ${(usedMemory * 100) / maxMemory}%"></div>
                                        </div>
                                    </div>
                                    <div class="memory-item">
                                        <div class="memory-label">
                                            <div class="color-indicator free"></div>
                                            <span>Còn trống</span>
                                        </div>
                                        <div class="memory-value">${freeMemory} MB</div>
                                        <div class="memory-bar">
                                            <div class="bar-fill free" style="width: ${(freeMemory * 100) / maxMemory}%"></div>
                                        </div>
                                    </div>
                                    <div class="memory-item">
                                        <div class="memory-label">
                                            <div class="color-indicator total"></div>
                                            <span>Tổng bộ nhớ JVM</span>
                                        </div>
                                        <div class="memory-value">${totalMemory} MB</div>
                                        <div class="memory-bar">
                                            <div class="bar-fill total" style="width: ${(totalMemory * 100) / maxMemory}%"></div>
                                        </div>
                                    </div>
                                    <div class="memory-item">
                                        <div class="memory-label">
                                            <div class="color-indicator max"></div>
                                            <span>Bộ nhớ tối đa JVM</span>
                                        </div>
                                        <div class="memory-value">${maxMemory} MB</div>
                                        <div class="memory-bar">
                                            <div class="bar-fill max" style="width: 100%"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- System Health -->
                        <div class="analytics-card system-health">
                            <div class="card-header">
                                <h3> Tình trạng hệ thống</h3>
                                <div class="health-status">
                                    <c:choose>
                                        <c:when test="${(usedMemory * 100) / totalMemory < 70}">
                                            <div class="status-indicator excellent">
                                                <div class="status-dot"></div>
                                                <span>Rất tốt</span>
                                            </div>
                                        </c:when>
                                        <c:when test="${(usedMemory * 100) / totalMemory < 85}">
                                            <div class="status-indicator good">
                                                <div class="status-dot"></div>
                                                <span>Tốt</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="status-indicator warning">
                                                <div class="status-dot"></div>
                                                <span>Cảnh báo</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="card-content">
                                <div class="health-metrics">
                                    <div class="health-metric">
                                        <div class="metric-icon-small">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M22 12h-4l-3 9L9 3l-3 9H2"/>
                                            </svg>
                                        </div>
                                        <div class="metric-info">
                                            <div class="metric-title">Mức sử dụng CPU</div>
                                            <div class="metric-subtitle">Ước tính dựa trên bộ nhớ</div>
                                        </div>
                                        <div class="metric-score">
                                            <c:choose>
                                                <c:when test="${(usedMemory * 100) / totalMemory < 50}">Low</c:when>
                                                <c:when test="${(usedMemory * 100) / totalMemory < 80}">Medium</c:when>
                                                <c:otherwise>High</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="health-metric">
                                        <div class="metric-icon-small">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="3"/>
                                            <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1 1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/>
                                            </svg>
                                        </div>
                                        <div class="metric-info">
                                            <div class="metric-title">Thời gian phản hồi</div>
                                            <div class="metric-subtitle">Thời gian xử lý trung bình</div>
                                        </div>
                                        <div class="metric-score">${avgResponseTime}ms</div>
                                    </div>
                                    <div class="health-metric">
                                        <div class="metric-icon-small">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                                            </svg>
                                        </div>
                                        <div class="metric-info">
                                            <div class="metric-title">Throughput</div>
                                            <div class="metric-subtitle">Trung bình lượt request trên mỗi phiên </div>
                                        </div>
                                        <div class="metric-score">${String.format("%.1f", requestCount / (activeSessions > 0 ? activeSessions : 1))}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    
                </div>

                <style>
                    .professional-dashboard {
                        padding: 24px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        min-height: 100vh;
                        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
                    }

                    .dashboard-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        background: rgba(255, 255, 255, 0.95);
                        backdrop-filter: blur(20px);
                        border-radius: 16px;
                        padding: 24px 32px;
                        margin-bottom: 32px;
                        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                    }

                    .header-left {
                        display: flex;
                        align-items: center;
                        gap: 16px;
                    }

                    .header-icon {
                        width: 48px;
                        height: 48px;
                        background: linear-gradient(135deg, #4f46e5, #7c3aed);
                        border-radius: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                    }

                    .header-text h1 {
                        margin: 0;
                        font-size: 24px;
                        font-weight: 700;
                        color: #1f2937;
                        line-height: 1.2;
                    }

                    .header-text p {
                        margin: 4px 0 0 0;
                        color: #6b7280;
                        font-size: 14px;
                    }

                    .header-right {
                        display: flex;
                        align-items: center;
                        gap: 16px;
                    }

                    .status-badge {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        padding: 8px 16px;
                        background: #dcfce7;
                        color: #166534;
                        border-radius: 20px;
                        font-size: 14px;
                        font-weight: 500;
                    }

                    .status-badge.online .status-dot {
                        width: 8px;
                        height: 8px;
                        background: #22c55e;
                        border-radius: 50%;
                        animation: pulse 2s infinite;
                    }

                    .refresh-button {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        padding: 10px 20px;
                        background: #4f46e5;
                        color: white;
                        border: none;
                        border-radius: 8px;
                        font-weight: 500;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .refresh-button:hover {
                        background: #4338ca;
                        transform: translateY(-1px);
                    }

                    .metrics-overview {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                        gap: 24px;
                        margin-bottom: 32px;
                    }

                    .metric-card {
                        background: rgba(255, 255, 255, 0.95);
                        backdrop-filter: blur(20px);
                        border-radius: 16px;
                        padding: 24px;
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                        transition: all 0.3s ease;
                        position: relative;
                        overflow: hidden;
                    }

                    .metric-card:hover {
                        transform: translateY(-4px);
                        box-shadow: 0 12px 48px rgba(0, 0, 0, 0.15);
                    }

                    .metric-card::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 4px;
                        background: linear-gradient(90deg, #4f46e5, #7c3aed);
                    }

                    .metric-card.success::before {
                        background: linear-gradient(90deg, #10b981, #059669);
                    }
                    .metric-card.warning::before {
                        background: linear-gradient(90deg, #f59e0b, #d97706);
                    }
                    .metric-card.info::before {
                        background: linear-gradient(90deg, #3b82f6, #2563eb);
                    }

                    .metric-icon {
                        width: 48px;
                        height: 48px;
                        border-radius: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin-bottom: 16px;
                    }

                    .metric-card.primary .metric-icon {
                        background: linear-gradient(135deg, #4f46e5, #7c3aed);
                        color: white;
                    }
                    .metric-card.success .metric-icon {
                        background: linear-gradient(135deg, #10b981, #059669);
                        color: white;
                    }
                    .metric-card.warning .metric-icon {
                        background: linear-gradient(135deg, #f59e0b, #d97706);
                        color: white;
                    }
                    .metric-card.info .metric-icon {
                        background: linear-gradient(135deg, #3b82f6, #2563eb);
                        color: white;
                    }

                    .metric-value {
                        font-size: 32px;
                        font-weight: 700;
                        color: #1f2937;
                        line-height: 1;
                        margin-bottom: 4px;
                    }

                    .metric-label {
                        color: #6b7280;
                        font-size: 14px;
                        font-weight: 500;
                        margin-bottom: 12px;
                    }

                    .metric-change {
                        display: flex;
                        align-items: center;
                        gap: 4px;
                        font-size: 12px;
                        font-weight: 600;
                    }

                    .metric-change.positive {
                        color: #059669;
                    }
                    .metric-change.negative {
                        color: #dc2626;
                    }
                    .metric-change.neutral {
                        color: #6b7280;
                    }

                    .progress-ring {
                        position: absolute;
                        top: 24px;
                        right: 24px;
                        width: 60px;
                        height: 60px;
                    }

                    .ring-text {
                        position: absolute;
                        top: 50%;
                        left: 50%;
                        transform: translate(-50%, -50%);
                        font-size: 12px;
                        font-weight: 600;
                        color: #4f46e5;
                    }

                    .metric-trend {
                        position: absolute;
                        bottom: 0;
                        right: 0;
                        width: 100px;
                        height: 40px;
                        overflow: hidden;
                    }

                    .trend-line {
                        position: relative;
                        width: 100%;
                        height: 100%;
                    }

                    .trend-point {
                        position: absolute;
                        width: 3px;
                        background: #10b981;
                        border-radius: 2px;
                        bottom: 0;
                        opacity: 0.7;
                    }

                    .metric-sparkline {
                        position: absolute;
                        bottom: 16px;
                        right: 24px;
                        opacity: 0.8;
                    }

                    .metric-gauge {
                        position: absolute;
                        bottom: 0;
                        left: 0;
                        right: 0;
                        height: 4px;
                        background: rgba(59, 130, 246, 0.1);
                    }

                    .gauge-fill {
                        height: 100%;
                        background: linear-gradient(90deg, #3b82f6, #2563eb);
                        transition: width 0.5s ease;
                    }

                    .analytics-section {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 24px;
                        margin-bottom: 32px;
                    }

                    .analytics-card {
                        background: rgba(255, 255, 255, 0.95);
                        backdrop-filter: blur(20px);
                        border-radius: 16px;
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                    }

                    .card-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 24px 24px 0 24px;
                    }

                    .card-header h3 {
                        margin: 0;
                        font-size: 18px;
                        font-weight: 600;
                        color: #1f2937;
                    }

                    .card-content {
                        padding: 24px;
                    }

                    .memory-breakdown {
                        display: flex;
                        flex-direction: column;
                        gap: 20px;
                    }

                    .memory-item {
                        display: flex;
                        align-items: center;
                        gap: 16px;
                    }

                    .memory-label {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        min-width: 120px;
                        font-size: 14px;
                        font-weight: 500;
                        color: #374151;
                    }

                    .color-indicator {
                        width: 12px;
                        height: 12px;
                        border-radius: 3px;
                    }

                    .color-indicator.used {
                        background: #ef4444;
                    }
                    .color-indicator.free {
                        background: #10b981;
                    }
                    .color-indicator.total {
                        background: #3b82f6;
                    }
                    .color-indicator.max {
                        background: #8b5cf6;
                    }

                    .memory-value {
                        min-width: 80px;
                        font-weight: 600;
                        color: #1f2937;
                    }

                    .memory-bar {
                        flex: 1;
                        height: 8px;
                        background: #f3f4f6;
                        border-radius: 4px;
                        overflow: hidden;
                    }

                    .bar-fill {
                        height: 100%;
                        border-radius: 4px;
                        transition: width 0.5s ease;
                    }

                    .bar-fill.used {
                        background: #ef4444;
                    }
                    .bar-fill.free {
                        background: #10b981;
                    }
                    .bar-fill.total {
                        background: #3b82f6;
                    }
                    .bar-fill.max {
                        background: #8b5cf6;
                    }

                    .health-status {
                        display: flex;
                        align-items: center;
                    }

                    .status-indicator {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        padding: 6px 12px;
                        border-radius: 20px;
                        font-size: 12px;
                        font-weight: 600;
                    }

                    .status-indicator.excellent {
                        background: #dcfce7;
                        color: #166534;
                    }

                    .status-indicator.good {
                        background: #fef3c7;
                        color: #92400e;
                    }

                    .status-indicator.warning {
                        background: #fee2e2;
                        color: #991b1b;
                    }

                    .status-indicator .status-dot {
                        width: 6px;
                        height: 6px;
                        border-radius: 50%;
                    }

                    .status-indicator.excellent .status-dot {
                        background: #22c55e;
                    }
                    .status-indicator.good .status-dot {
                        background: #f59e0b;
                    }
                    .status-indicator.warning .status-dot {
                        background: #ef4444;
                    }

                    .health-metrics {
                        display: flex;
                        flex-direction: column;
                        gap: 16px;
                    }

                    .health-metric {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        padding: 16px;
                        background: #f9fafb;
                        border-radius: 12px;
                    }

                    .metric-icon-small {
                        width: 40px;
                        height: 40px;
                        background: #4f46e5;
                        border-radius: 10px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                    }

                    .metric-info {
                        flex: 1;
                    }

                    .metric-title {
                        font-weight: 600;
                        color: #1f2937;
                        font-size: 14px;
                    }

                    .metric-subtitle {
                        color: #6b7280;
                        font-size: 12px;
                        margin-top: 2px;
                    }

                    .metric-score {
                        font-weight: 700;
                        color: #4f46e5;
                        font-size: 16px;
                    }

                    .timeline-section {
                        margin-bottom: 32px;
                    }

                    .timeline-card {
                        background: rgba(255, 255, 255, 0.95);
                        backdrop-filter: blur(20px);
                        border-radius: 16px;
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                    }

                    .timeline-controls {
                        display: flex;
                        gap: 8px;
                    }

                    .timeline-btn {
                        padding: 6px 12px;
                        border: 1px solid #e5e7eb;
                        background: white;
                        border-radius: 6px;
                        font-size: 12px;
                        font-weight: 500;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .timeline-btn.active {
                        background: #4f46e5;
                        color: white;
                        border-color: #4f46e5;
                    }

                    .timeline-chart {
                        position: relative;
                        height: 200px;
                        margin-top: 16px;
                    }

                    .chart-grid {
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                    }

                    .grid-line {
                        position: absolute;
                        left: 0;
                        right: 0;
                        height: 1px;
                        background: #f3f4f6;
                    }

                    .chart-tooltip {
                        position: absolute;
                        top: 20px;
                        right: 20px;
                        background: rgba(255, 255, 255, 0.95);
                        backdrop-filter: blur(10px);
                        padding: 12px 16px;
                        border-radius: 8px;
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
                    }

                    .tooltip-title {
                        font-size: 12px;
                        color: #6b7280;
                        margin-bottom: 4px;
                    }

                    .tooltip-value {
                        font-weight: 600;
                        color: #1f2937;
                    }

                    @keyframes pulse {
                        0%, 100% {
                            opacity: 1;
                        }
                        50% {
                            opacity: 0.5;
                        }
                    }

                    @media (max-width: 1024px) {
                        .analytics-section {
                            grid-template-columns: 1fr;
                        }
                    }

                    @media (max-width: 768px) {
                        .professional-dashboard {
                            padding: 16px;
                        }

                        .dashboard-header {
                            flex-direction: column;
                            gap: 16px;
                            text-align: center;
                        }

                        .metrics-overview {
                            grid-template-columns: 1fr;
                        }

                        .header-left {
                            flex-direction: column;
                            text-align: center;
                        }
                    }
                </style>

                <script>
                    function refreshDashboard() {
                        // Add loading state
                        const refreshBtn = document.querySelector('.refresh-button');
                        const originalText = refreshBtn.innerHTML;
                        refreshBtn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="animate-spin"><path d="M21 12a9 9 0 11-6.219-8.56"/></svg> Refreshing...';
                        refreshBtn.disabled = true;

                        // Simulate refresh delay
                        setTimeout(() => {
                            location.reload();
                        }, 1000);
                    }

                // Auto refresh every
                    setInterval(refreshDashboard, 600000);

                // Initialize tooltips and animations
                    document.addEventListener('DOMContentLoaded', function () {
                        // Animate progress rings
                        const rings = document.querySelectorAll('.progress-ring circle:last-child');
                        rings.forEach(ring => {
                            const circumference = 2 * Math.PI * 25;
                            ring.style.strokeDasharray = circumference;
                            ring.style.transition = 'stroke-dashoffset 1s ease-in-out';
                        });

                        // Animate metric cards on scroll
                        const observer = new IntersectionObserver((entries) => {
                            entries.forEach(entry => {
                                if (entry.isIntersecting) {
                                    entry.target.style.opacity = '1';
                                    entry.target.style.transform = 'translateY(0)';
                                }
                            });
                        });

                        document.querySelectorAll('.metric-card, .analytics-card').forEach(card => {
                            card.style.opacity = '0';
                            card.style.transform = 'translateY(20px)';
                            card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                            observer.observe(card);
                        });
                    });
                </script>

            </div>
        </div>
    </body>
</html>