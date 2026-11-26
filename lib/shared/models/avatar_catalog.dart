/// Emoji portraits used as lightweight, private profile avatars.
class AvatarCatalog {
  AvatarCatalog._();

  static const options = [
    '👩🏿', '👩🏾', '👩🏽', '👩🏼', '👩🏻',
    '👩🏿‍🦱', '👩🏽‍🦱', '👩🏻‍🦰', '👩🏾‍🦳', '👩🏼‍🦰',
    '🧑🏿', '🧑🏾', '🧑🏽', '🧑🏼', '🧑🏻',
    '👨🏿', '👨🏾', '👨🏽', '👨🏼', '👨🏻',
  ];

  static String glyph(int index) =>
      options[index.clamp(0, options.length - 1).toInt()];
}
