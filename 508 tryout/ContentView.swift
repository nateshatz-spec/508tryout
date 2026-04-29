import SwiftUI
import Charts

// MARK: - Theme Colors
struct ThemeColors {
    static let bg = Color(red: 5/255, green: 8/255, blue: 17/255)
    static let bgSecondary = Color(red: 10/255, green: 15/255, blue: 28/255)
    static let textPrimary = Color(red: 248/255, green: 250/255, blue: 252/255)
    static let textSecondary = Color(red: 148/255, green: 163/255, blue: 184/255)
    static let accent = Color(red: 15/255, green: 150/255, blue: 216/255)
    static let glassBorder = Color.white.opacity(0.08)
    static let glassBg = Color.white.opacity(0.02)
    static let trendUp = Color(red: 16/255, green: 185/255, blue: 129/255) // #10b981
    static let trendDown = Color(red: 239/255, green: 68/255, blue: 68/255) // #ef4444
}

// MARK: - Main Tab View
struct ContentView: View {
    init() {
        // Customize TabBar appearance to match the dark theme
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 10/255, green: 15/255, blue: 28/255, alpha: 1.0)
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)]
        
        itemAppearance.selected.iconColor = UIColor(red: 15/255, green: 150/255, blue: 216/255, alpha: 1.0)
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(red: 15/255, green: 150/255, blue: 216/255, alpha: 1.0)]
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        // Customize NavigationBar appearance
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(red: 10/255, green: 15/255, blue: 28/255, alpha: 1.0)
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
    }

    var body: some View {
        TabView {
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }
            
            CampaignsView()
                .tabItem {
                    Label("Campaigns", systemImage: "megaphone.fill")
                }
            
            LeadsView()
                .tabItem {
                    Label("Leads", systemImage: "person.2.fill")
                }
            
            InboxView()
                .tabItem {
                    Label("Inbox", systemImage: "tray.full.fill")
                }
        }
        .preferredColorScheme(.dark)
        .tint(ThemeColors.accent)
    }
}

// MARK: - Analytics View
struct AnalyticsView: View {
    
    struct TrafficData: Identifiable {
        let id = UUID()
        let month: String
        let traffic: Int
    }
    
    let chartData = [
        TrafficData(month: "Jan", traffic: 4000),
        TrafficData(month: "Feb", traffic: 5200),
        TrafficData(month: "Mar", traffic: 5800),
        TrafficData(month: "Apr", traffic: 7100),
        TrafficData(month: "May", traffic: 8500),
        TrafficData(month: "Jun", traffic: 9200),
        TrafficData(month: "Jul", traffic: 11000),
        TrafficData(month: "Aug", traffic: 12500)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ThemeColors.bg.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Metrics Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            MetricCard(title: "Total Leads", value: "342", trend: "↑ 12%", isUp: true)
                            MetricCard(title: "Website Traffic", value: "12.5k", trend: "↑ 8.4%", isUp: true)
                            MetricCard(title: "Conversion Rate", value: "2.7%", trend: "↑ 0.3%", isUp: true)
                            MetricCard(title: "Cost per Lead", value: "$42.50", trend: "↓ 5%", isUp: false)
                        }
                        
                        // Interactive Chart Area
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Traffic Growth (YTD)")
                                .font(.headline)
                                .foregroundColor(ThemeColors.textPrimary)
                            
                            Chart(chartData) { item in
                                LineMark(
                                    x: .value("Month", item.month),
                                    y: .value("Traffic", item.traffic)
                                )
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                .foregroundStyle(ThemeColors.accent)
                                
                                PointMark(
                                    x: .value("Month", item.month),
                                    y: .value("Traffic", item.traffic)
                                )
                                .foregroundStyle(ThemeColors.accent)
                                
                                AreaMark(
                                    x: .value("Month", item.month),
                                    y: .value("Traffic", item.traffic)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [ThemeColors.accent.opacity(0.3), ThemeColors.accent.opacity(0.0)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                            .chartYAxis {
                                AxisMarks(position: .leading) { value in
                                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5)).foregroundStyle(ThemeColors.glassBorder)
                                    AxisTick().foregroundStyle(Color.clear)
                                    AxisValueLabel().foregroundStyle(ThemeColors.textSecondary)
                                }
                            }
                            .chartXAxis {
                                AxisMarks(values: .automatic) { value in
                                    AxisValueLabel().foregroundStyle(ThemeColors.textSecondary)
                                }
                            }
                            .frame(height: 220)
                        }
                        .padding()
                        .background(ThemeColors.glassBg)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(ThemeColors.glassBorder, lineWidth: 1))
                        
                        // Campaign ROI Breakdown
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Top Performing Campaigns")
                                .font(.headline)
                                .foregroundColor(ThemeColors.textPrimary)
                            
                            VStack(spacing: 12) {
                                ROIRow(campaign: "Q4 B2B SaaS", leads: "145", roi: "320%")
                                Divider().background(ThemeColors.glassBorder)
                                ROIRow(campaign: "Local SEO Blast", leads: "98", roi: "210%")
                                Divider().background(ThemeColors.glassBorder)
                                ROIRow(campaign: "Retargeting Ads", leads: "42", roi: "150%")
                            }
                        }
                        .padding()
                        .background(ThemeColors.glassBg)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(ThemeColors.glassBorder, lineWidth: 1))
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Analytics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Circle()
                        .fill(ThemeColors.accent)
                        .frame(width: 32, height: 32)
                        .overlay(Text("C").font(.system(size: 14, weight: .bold)).foregroundColor(.white))
                }
            }
        }
    }
}

struct ROIRow: View {
    let campaign: String
    let leads: String
    let roi: String
    
    var body: some View {
        HStack {
            Text(campaign)
                .font(.subheadline)
                .foregroundColor(ThemeColors.textPrimary)
            Spacer()
            Text("\(leads) Leads")
                .font(.subheadline)
                .foregroundColor(ThemeColors.textSecondary)
            Text(roi)
                .font(.subheadline)
                .bold()
                .foregroundColor(ThemeColors.trendUp)
                .frame(width: 60, alignment: .trailing)
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let trend: String
    let isUp: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(ThemeColors.textSecondary)
                .tracking(1)
            
            Text(value)
                .font(.system(size: 28, weight: .heavy))
                .foregroundColor(ThemeColors.textPrimary)
            
            Text(trend)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(isUp ? ThemeColors.trendUp : ThemeColors.trendDown)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ThemeColors.glassBg)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(ThemeColors.glassBorder, lineWidth: 1))
    }
}

// MARK: - Campaigns View
struct CampaignsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                ThemeColors.bg.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        CampaignCard(title: "Q4 B2B SaaS Outreach", status: "Active", leads: "24 Leads Generated", color: ThemeColors.accent)
                        CampaignCard(title: "Local SEO Blast", status: "Active", leads: "18 Leads Generated", color: ThemeColors.trendUp)
                        CampaignCard(title: "Retargeting Ad Campaign", status: "Paused", leads: "12 Leads Generated", color: ThemeColors.textSecondary)
                        
                        Text("Recent Campaign Activity")
                            .font(.headline)
                            .foregroundColor(ThemeColors.textPrimary)
                            .padding(.top, 10)
                        
                        VStack(spacing: 0) {
                            ActivityRow(action: "New Lead Captured", detail: "Alex Mercer (TechFlow)", time: "2 hours ago")
                            Divider().background(ThemeColors.glassBorder).padding(.leading, 40)
                            ActivityRow(action: "Campaign Paused", detail: "Retargeting Ads budget reached", time: "Yesterday")
                            Divider().background(ThemeColors.glassBorder).padding(.leading, 40)
                            ActivityRow(action: "Email Opened", detail: "Samantha Wright (Acme Corp)", time: "2 days ago")
                        }
                        .background(ThemeColors.glassBg)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(ThemeColors.glassBorder, lineWidth: 1))
                    }
                    .padding()
                }
            }
            .navigationTitle("Campaigns")
        }
    }
}

struct CampaignCard: View {
    let title: String
    let status: String
    let leads: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(ThemeColors.textPrimary)
            
            Text(status)
                .font(.title2)
                .bold()
                .foregroundColor(color)
            
            Text(leads)
                .font(.subheadline)
                .foregroundColor(ThemeColors.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ThemeColors.glassBg)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ThemeColors.glassBorder, lineWidth: 1)
        )
        .overlay(
            Rectangle()
                .fill(color)
                .frame(width: 4)
                .padding(.vertical, 1)
            , alignment: .leading
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ActivityRow: View {
    let action: String
    let detail: String
    let time: String
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(ThemeColors.accent.opacity(0.2))
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(action)
                    .font(.subheadline)
                    .foregroundColor(ThemeColors.textPrimary)
                Text(detail)
                    .font(.caption)
                    .foregroundColor(ThemeColors.textSecondary)
            }
            Spacer()
            Text(time)
                .font(.caption)
                .foregroundColor(ThemeColors.textSecondary)
        }
        .padding()
    }
}


// MARK: - Leads View
struct LeadsView: View {
    struct Lead: Identifiable {
        let id = UUID()
        let name: String
        let company: String
        let status: String
        let email: String
        let source: String
        let date: String
    }
    
    let leads = [
        Lead(name: "Sarah Jenkins", company: "Acme Corp", status: "Active", email: "sarah@acmecorp.com", source: "Inbound Website", date: "Oct 24, 2026"),
        Lead(name: "Michael Chen", company: "TechFlow Startups", status: "Negotiating", email: "m.chen@techflow.io", source: "Q4 B2B SaaS", date: "Oct 22, 2026"),
        Lead(name: "Elena Rodriguez", company: "DesignWorks", status: "New", email: "elena@designworks.com", source: "Local SEO Blast", date: "Oct 20, 2026"),
        Lead(name: "David Smith", company: "Smith Consulting", status: "Active", email: "david@smithconsulting.com", source: "Retargeting Ads", date: "Oct 15, 2026")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ThemeColors.bg.ignoresSafeArea()
                
                List {
                    ForEach(leads) { lead in
                        NavigationLink(destination: LeadDetailView(lead: lead)) {
                            HStack {
                                Circle()
                                    .fill(ThemeColors.bgSecondary)
                                    .frame(width: 40, height: 40)
                                    .overlay(Text(String(lead.name.prefix(1))).foregroundColor(ThemeColors.accent).bold())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(lead.name)
                                        .font(.headline)
                                        .foregroundColor(ThemeColors.textPrimary)
                                    Text(lead.company)
                                        .font(.subheadline)
                                        .foregroundColor(ThemeColors.textSecondary)
                                }
                                
                                Spacer()
                                
                                Text(lead.status)
                                    .font(.caption)
                                    .bold()
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(ThemeColors.accent.opacity(0.1))
                                    .foregroundColor(ThemeColors.accent)
                                    .cornerRadius(8)
                            }
                        }
                        .listRowBackground(ThemeColors.bg)
                        .listRowSeparatorTint(ThemeColors.glassBorder)
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Active Leads")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .foregroundColor(ThemeColors.accent)
                    }
                }
            }
        }
    }
}

struct LeadDetailView: View {
    let lead: LeadsView.Lead
    
    var body: some View {
        ZStack {
            ThemeColors.bg.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    Circle()
                        .fill(ThemeColors.bgSecondary)
                        .frame(width: 80, height: 80)
                        .overlay(Text(String(lead.name.prefix(1))).font(.largeTitle).foregroundColor(ThemeColors.accent).bold())
                        .padding(.top, 20)
                    
                    Text(lead.name)
                        .font(.title)
                        .bold()
                        .foregroundColor(ThemeColors.textPrimary)
                    
                    Text(lead.company)
                        .font(.title3)
                        .foregroundColor(ThemeColors.textSecondary)
                    
                    Text(lead.status)
                        .font(.subheadline)
                        .bold()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(ThemeColors.accent.opacity(0.1))
                        .foregroundColor(ThemeColors.accent)
                        .cornerRadius(12)
                        .padding(.bottom, 20)
                    
                    VStack(spacing: 0) {
                        DetailRow(title: "Email", value: lead.email)
                        Divider().background(ThemeColors.glassBorder).padding(.leading, 16)
                        DetailRow(title: "Source", value: lead.source)
                        Divider().background(ThemeColors.glassBorder).padding(.leading, 16)
                        DetailRow(title: "Date Captured", value: lead.date)
                    }
                    .background(ThemeColors.glassBg)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(ThemeColors.glassBorder, lineWidth: 1))
                    .padding(.horizontal)
                    
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Label("Email Lead", systemImage: "envelope.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(ThemeColors.accent)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "phone.fill")
                                .font(.headline)
                                .foregroundColor(ThemeColors.textPrimary)
                                .padding()
                                .background(ThemeColors.bgSecondary)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Lead Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(ThemeColors.textSecondary)
            Spacer()
            Text(value)
                .foregroundColor(ThemeColors.textPrimary)
        }
        .padding()
    }
}

// MARK: - Inbox View
struct InboxView: View {
    struct Email: Identifiable {
        let id = UUID()
        let sender: String
        let subject: String
        let preview: String
        let fullMessage: String
        let date: String
        var isUnread: Bool
        var isStarred: Bool
    }
    
    @State private var emails = [
        Email(sender: "Sarah Jenkins", subject: "Website Redesign Inquiry", preview: "Hi there, we are looking to revamp our...", fullMessage: "Hi there,\n\nWe are looking to revamp our agency website. Our current site is over 5 years old and doesn't convert well. We loved the work you did for Acme Corp and want to discuss a similar project.\n\nBest,\nSarah", date: "10:42 AM", isUnread: true, isStarred: false),
        Email(sender: "Michael Chen", subject: "SEO Services Quote", preview: "I found you via Google and I'm interested...", fullMessage: "I found you via Google and I'm interested in your local SEO packages for my dental practice in Boston. Can you send over a pricing sheet?\n\n- Michael", date: "Yesterday", isUnread: true, isStarred: false),
        Email(sender: "Acme Corp", subject: "Partnership Opportunity", preview: "We love your creative design work and want to discuss...", fullMessage: "Hello 508 team,\n\nWe love your creative design work and want to discuss a potential partnership where we white-label your services for our clients.\n\nThanks!", date: "Oct 12", isUnread: false, isStarred: true),
        Email(sender: "David Smith", subject: "Following up on proposal", preview: "Thanks for the call yesterday. I have a few questions...", fullMessage: "Thanks for the call yesterday. I have a few questions about the timeline you proposed. Can we hop on a quick call tomorrow?", date: "Oct 10", isUnread: false, isStarred: false)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ThemeColors.bg.ignoresSafeArea()
                
                List {
                    ForEach($emails) { $email in
                        NavigationLink(destination: EmailDetailView(email: $email)) {
                            VStack(spacing: 0) {
                                HStack(spacing: 12) {
                                    // Star icon
                                    Image(systemName: email.isStarred ? "star.fill" : "star")
                                        .foregroundColor(email.isStarred ? ThemeColors.accent : ThemeColors.textSecondary)
                                        .font(.system(size: 16))
                                        .onTapGesture {
                                            email.isStarred.toggle()
                                        }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(email.sender)
                                                .font(.system(size: 16, weight: email.isUnread ? .bold : .regular))
                                                .foregroundColor(email.isUnread ? ThemeColors.textPrimary : ThemeColors.textSecondary)
                                            Spacer()
                                            Text(email.date)
                                                .font(.system(size: 12))
                                                .foregroundColor(ThemeColors.textSecondary)
                                        }
                                        
                                        HStack(spacing: 4) {
                                            Text(email.subject)
                                                .font(.system(size: 14, weight: email.isUnread ? .bold : .regular))
                                                .foregroundColor(email.isUnread ? ThemeColors.accent : ThemeColors.textSecondary)
                                            
                                            Text("- " + email.preview)
                                                .font(.system(size: 14))
                                                .foregroundColor(ThemeColors.textSecondary)
                                                .lineLimit(1)
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .listRowBackground(email.isUnread ? ThemeColors.glassBg : ThemeColors.bg)
                        .listRowSeparatorTint(ThemeColors.glassBorder)
                        .swipeActions(edge: .leading) {
                            Button { email.isUnread.toggle() } label: {
                                Label(email.isUnread ? "Read" : "Unread", systemImage: email.isUnread ? "envelope.open.fill" : "envelope.fill")
                            }
                            .tint(ThemeColors.accent)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                if let index = emails.firstIndex(where: { $0.id == email.id }) {
                                    emails.remove(at: index)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Inbox")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(ThemeColors.accent)
                    }
                }
            }
        }
    }
}

struct EmailDetailView: View {
    @Binding var email: InboxView.Email
    
    var body: some View {
        ZStack {
            ThemeColors.bg.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(email.subject)
                        .font(.title2)
                        .bold()
                        .foregroundColor(ThemeColors.textPrimary)
                    
                    HStack {
                        Circle()
                            .fill(ThemeColors.bgSecondary)
                            .frame(width: 44, height: 44)
                            .overlay(Text(String(email.sender.prefix(1))).foregroundColor(ThemeColors.accent).bold())
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(email.sender)
                                .font(.headline)
                                .foregroundColor(ThemeColors.textPrimary)
                            Text(email.date)
                                .font(.caption)
                                .foregroundColor(ThemeColors.textSecondary)
                        }
                        Spacer()
                    }
                    
                    Divider().background(ThemeColors.glassBorder)
                    
                    Text(email.fullMessage)
                        .font(.body)
                        .foregroundColor(ThemeColors.textPrimary)
                        .lineSpacing(6)
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {}) {
                            Label("Reply", systemImage: "arrowshape.turn.up.left.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(ThemeColors.accent)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.top, 40)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            email.isUnread = false
        }
    }
}

#Preview {
    ContentView()
}
