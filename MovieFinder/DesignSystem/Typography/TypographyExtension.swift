import SwiftUI

// MARK: - Typography Modifiers

/// Style สำหรับหัวข้อที่ใหญ่ที่สุดในหน้า (Display Title)
struct DisplayTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 34, weight: .bold)).foregroundStyle(
                .textPrimary
            )
    }
}

/// Style สำหรับหัวข้อหลักของหน้า (Headline)
struct HeadlineStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 28, weight: .bold)).foregroundStyle(
                .textPrimary
            )
    }
}

/// Style สำหรับหัวข้อของแต่ละ Section (Title 1)
struct Title1Style: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 22, weight: .bold)).foregroundStyle(
                .textPrimary
            )
    }
}

/// Style สำหรับชื่อของรายการต่างๆ (Title 2)
struct Title2Style: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .semibold)).foregroundStyle(
                .textPrimary
            )
    }
}

/// Style สำหรับข้อความเนื้อหาหลัก (Body)
struct BodyStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .regular)).foregroundStyle(
                .textPrimary
            )
            .lineSpacing(4)  // เพิ่มระยะห่างระหว่างบรรทัด
    }
}

/// Style สำหรับข้อความรอง หรือข้อมูลเสริม (Subheadline)
struct SubheadlineStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .medium)).foregroundStyle(
                .textPrimary
            )
    }
}

/// Style สำหรับข้อความคำอธิบายเล็กๆ (Callout)
struct CalloutStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 13, weight: .regular)).foregroundStyle(
                .textPrimary
            )
    }
}

/// Style สำหรับข้อความที่เล็กที่สุด (Caption)
struct CaptionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 11, weight: .medium)).foregroundStyle(
                .textPrimary
            )
    }
}

/// Style สำหรับข้อความบนปุ่ม (Button)
struct ButtonLabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .semibold)).foregroundStyle(
                .textPrimary
            )
    }
}

// MARK: - View Extension for Easy Access

extension View {
    func displayTitleStyle() -> some View { self.modifier(DisplayTitleStyle()) }
    func headlineStyle() -> some View { self.modifier(HeadlineStyle()) }
    func title1Style() -> some View { self.modifier(Title1Style()) }
    func title2Style() -> some View { self.modifier(Title2Style()) }
    func bodyStyle() -> some View { self.modifier(BodyStyle()) }
    func subheadlineStyle() -> some View { self.modifier(SubheadlineStyle()) }
    func calloutStyle() -> some View { self.modifier(CalloutStyle()) }
    func captionStyle() -> some View { self.modifier(CaptionStyle()) }
    func buttonLabelStyle() -> some View { self.modifier(ButtonLabelStyle()) }
}
