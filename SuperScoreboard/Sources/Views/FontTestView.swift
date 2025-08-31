//
//  FontTestView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI

struct FontTestView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Font System Test")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                // Headings Large - Druk Wide Bold
                VStack(alignment: .leading, spacing: 8) {
                    Text("Headings/Large - Druk Wide Bold (34px)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("CHAMPIONS LEAGUE")
                        .customFont(.headingsLarge)
                    
                    Text("CHAMPIONS LEAGUE")
                        .customFont(.headingsLarge, color: .surfaceBase)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.fillPrimary)
                        .cornerRadius(8)
                }
                
                Divider()
                
                // Heading Title 3 - Druk Wide Bold
                VStack(alignment: .leading, spacing: 8) {
                    Text("Heading/Title 3 - Druk Wide Bold (16px)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("Premier League")
                        .customFont(.headingTitle3)
                    
                    Text("Premier League")
                        .customFont(.headingTitle3, color: .surfaceBase)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(.fillPrimary)
                        .cornerRadius(4)
                }
                
                Divider()
                
                // Body Medium - Selecta Trial Medium
                VStack(alignment: .leading, spacing: 8) {
                    Text("Body/Medium - Selecta Trial Medium (16px)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("Manchester United")
                        .customFont(.bodyMedium)
                    
                    Text("Manchester United")
                        .customFont(.bodyMedium, color: .surfaceBase)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(.fillPrimary)
                        .cornerRadius(4)
                }
                
                Divider()
                
                // Callout Bold - Selecta Trial Bold
                VStack(alignment: .leading, spacing: 8) {
                    Text("Callout/Bold - Selecta Trial Bold (16px)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("2 - 1")
                        .customFont(.calloutBold)
                    
                    Text("2 - 1")
                        .customFont(.calloutBold, color: .surfaceBase)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(.fillPrimary)
                        .cornerRadius(4)
                }
                
                Divider()
                
                // Body Small - Selecta Trial Regular
                VStack(alignment: .leading, spacing: 8) {
                    Text("Body S - Selecta Trial Regular (12px)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("Full Time")
                        .customFont(.bodySmall)
                    
                    Text("Full Time")
                        .customFont(.bodySmall, color: .surfaceBase)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(.fillPrimary)
                        .cornerRadius(4)
                }
                
                Divider()
                
                // Caption - Selecta Trial Medium
                VStack(alignment: .leading, spacing: 8) {
                    Text("Caption 1/Regular - Selecta Trial Medium (12.94px)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("Old Trafford")
                        .customFont(.caption)
                    
                    Text("Old Trafford")
                        .customFont(.caption, color: .surfaceBase)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(.fillPrimary)
                        .cornerRadius(4)
                }
                
                Divider()
                
                // Time Number - Selecta Trial Regular
                VStack(alignment: .leading, spacing: 8) {
                    Text("Time Number - Selecta Trial Regular (12px)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("90+2'")
                        .customFont(.timeNumber)
                    
                    Text("90+2'")
                        .customFont(.timeNumber, color: .surfaceBase)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.fillPrimary)
                        .cornerRadius(4)
                }
                
                Divider()
                
                // Color System Test
                VStack(alignment: .leading, spacing: 16) {
                    Text("Color System Test")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 16) {
                        VStack {
                            Rectangle()
                                .fill(.textIconDefaultBlack)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            Text(".textIconDefault")
                                .font(.caption)
                            Text("#1C1B19")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Rectangle()
                                .fill(.fillPrimary)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            Text(".fillPrimary")
                                .font(.caption)
                            Text("#787880 20%")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Rectangle()
                                .fill(.surfaceBase)
                                .stroke(.gray, lineWidth: 1)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            Text(".surfaceBase")
                                .font(.caption)
                            Text("#FFFFFF")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Divider()
                
                // Real-world Example
                VStack(alignment: .leading, spacing: 12) {
                    Text("Real-world Example")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 12) {
                        // Competition header
                        Text("Premier League")
                            .customFont(.headingTitle3)
                        
                        // Match card simulation
                        HStack {
                            VStack {
                                Text("MAN UTD")
                                    .customFont(.bodyMedium)
                                Text("2")
                                    .customFont(.calloutBold)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("90+2'")
                                    .customFont(.timeNumber, color: .surfaceBase)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.fillPrimary)
                                    .cornerRadius(4)
                                
                                Text("Old Trafford")
                                    .customFont(.caption)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("LIVERPOOL")
                                    .customFont(.bodyMedium)
                                Text("1")
                                    .customFont(.calloutBold)
                            }
                        }
                        .padding()
                        .background(.surfaceBase)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Font Test")
    }
}

#Preview {
    NavigationView {
        FontTestView()
    }
}
