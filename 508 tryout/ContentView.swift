import SwiftUI

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
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
    }

    var body: some View {
        TabView {
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
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
    }
}

// MARK: - Analytics View
struct AnalyticsView: View {
    var body: some View {
        ZStack {
            ThemeColors.bg.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Top Bar
                    HStack {
                        Text("Dashboard Overview")
                            .font(.title2)
                            .bold()
                            .foregroundColor(ThemeColors.textPrimary)
                        Spacer()
                        Circle()
                            .fill(ThemeColors.accent)
                            .frame(width: 40, height: 40)
                            .overlay(Text("C").bold().foregroundColor(.white))
                    }
                    .padding(.top)
                    
                    // Metrics Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        MetricCard(title: "Total Leads", value: "342", trend: "↑ 12%", isUp: true)
                        MetricCard(title: "Website Traffic", value: "12.5k", trend: "↑ 8.4%", isUp: true)
                        MetricCard(title: "Conversion Rate", value: "2.7%", trend: "↑ 0.3%", isUp: true)
                        MetricCard(title: "Cost per Lead", value: "$42.50", trend: "↓ 5%", isUp: false)
                    }
                    
                    // Charts Placeholder
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Traffic & Lead Growth (YTD)")
                            .font(.headline)
                            .foregroundColor(ThemeColors.textPrimary)
                        
                        // Fake chart visual
                        GeometryReader { geo in
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: geo.size.height))
                                path.addLine(to: CGPoint(x: geo.size.width * 0.2, y: geo.size.height * 0.6))
                                path.addLine(to: CGPoint(x: geo.size.width * 0.5, y: geo.size.height * 0.8))
                                path.addLine(to: CGPoint(x: geo.size.width * 0.8, y: geo.size.height * 0.3))
                                path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height * 0.1))
                            }
                            .stroke(ThemeColors.accent, lineWidth: 3)
                            
                            // Dots
                            Circle().fill(ThemeColors.accent).frame(width: 8, height: 8).position(x: 0, y: geo.size.height)
                            Circle().fill(ThemeColors.accent).frame(width: 8, height: 8).position(x: geo.size.width * 0.2, y: geo.size.height * 0.6)
                            Circle().fill(ThemeColors.accent).frame(width: 8, height: 8).position(x: geo.size.width * 0.5, y: geo.size.height * 0.8)
                            Circle().fill(ThemeColors.accent).frame(width: 8, height: 8).position(x: geo.size.width * 0.8, y: geo.size.height * 0.3)
                            Circle().fill(ThemeColors.accent).frame(width: 8, height: 8).position(x: geo.size.width, y: geo.size.height * 0.1)
                        }
                        .frame(height: 150)
                        .padding()
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

// MARK: - Leads View
struct LeadsView: View {
    struct Lead: Identifiable {
        let id = UUID()
        let name: String
        let company: String
        let status: String
    }
    
    let leads = [
        Lead(name: "Sarah Jenkins", company: "Acme Corp", status: "Active"),
        Lead(name: "Michael Chen", company: "TechFlow Startups", status: "Negotiating"),
        Lead(name: "Elena Rodriguez", company: "DesignWorks", status: "New"),
        Lead(name: "David Smith", company: "Smith Consulting", status: "Active")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ThemeColors.bg.ignoresSafeArea()
                
                List {
                    ForEach(leads) { lead in
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
                        .listRowBackground(ThemeColors.bg)
                        .listRowSeparatorTint(ThemeColors.glassBorder)
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Active Leads")
            .navigationBarTitleDisplayMode(.inline)
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

// MARK: - Inbox View
struct InboxView: View {
    struct Email: Identifiable {
        let id = UUID()
        let sender: String
        let subject: String
        let preview: String
        let date: String
        let isUnread: Bool
        let isStarred: Bool
    }
    
    let emails = [
        Email(sender: "Sarah Jenkins", subject: "Website Redesign Inquiry", preview: "Hi there, we are looking to revamp our...", date: "10:42 AM", isUnread: true, isStarred: false),
        Email(sender: "Michael Chen", subject: "SEO Services Quote", preview: "I found you via Google and I'm interested...", date: "Yesterday", isUnread: true, isStarred: false),
        Email(sender: "Acme Corp", subject: "Partnership Opportunity", preview: "We love your creative design work and want to discuss...", date: "Oct 12", isUnread: true, isStarred: true),
        Email(sender: "David Smith", subject: "Following up on proposal", preview: "Thanks for the call yesterday. I have a few questions...", date: "Oct 10", isUnread: false, isStarred: false),
        Email(sender: "Elena Rodriguez", subject: "New brand identity", preview: "Are you available to take on a new branding project...", date: "Oct 05", isUnread: false, isStarred: false)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ThemeColors.bg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(emails) { email in
                            VStack(spacing: 0) {
                                HStack(spacing: 12) {
                                    // Star icon
                                    Image(systemName: email.isStarred ? "star.fill" : "star")
                                        .foregroundColor(email.isStarred ? ThemeColors.accent : ThemeColors.textSecondary)
                                        .font(.system(size: 16))
                                    
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
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(email.isUnread ? ThemeColors.glassBg : Color.clear)
                                
                                Divider().background(ThemeColors.glassBorder)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Inbox")
            .navigationBarTitleDisplayMode(.inline)
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

#Preview {
    ContentView()
}
