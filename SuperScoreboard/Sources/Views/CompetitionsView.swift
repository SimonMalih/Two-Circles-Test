import SwiftUI
import Domain

struct CompetitionsView: View {
    private let viewModel: CompetitionsViewModel = CompetitionsViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    if viewModel.isLoading && !viewModel.sectionsData.isEmpty {
                        ProgressView()
                            .scaleEffect(0.8)
                            .padding(.top, 8)
                    }
                    
                    ForEach(viewModel.sectionsData, id: \.title) { section in
                        CompetitionSectionView(sectionData: section)
                    }
                }
                .padding(.horizontal, 16)
            }
            .refreshable {
                await viewModel.fetchMatches()
            }
            .background(.primaryBackground)
            .navigationBarHidden(true)
        }
        .task {
            await viewModel.fetchMatches()
        }
    }
}

#Preview {
    CompetitionsView()
}
