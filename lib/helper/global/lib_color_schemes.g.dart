import 'package:flutter/material.dart';

const seed = Color(0xFF6750A4);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF5555A8),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFE1E0FF),
  onPrimaryContainer: Color(0xFF0E0664),
  secondary: Color(0xFF066E1E),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF9BF896),
  onSecondaryContainer: Color(0xFF002203),
  tertiary: Color(0xFF616200),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFE8E970),
  onTertiaryContainer: Color(0xFF1D1D00),
  error: Color(0xFFB3261E),
  errorContainer: Color(0xFFF9DEDC),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410E0B),
  background: Color(0xFFFFFBFE),
  onBackground: Color(0xFF1C1B1F),
  surface: Color(0xFFFFFBFE),
  onSurface: Color(0xFF1C1B1F),
  surfaceVariant: Color(0xFFE7E0EC),
  onSurfaceVariant: Color(0xFF49454F),
  outline: Color(0xFF79747E),
  onInverseSurface: Color(0xFFF4EFF4),
  inverseSurface: Color(0xFF313033),
  inversePrimary: Color(0xFFC1C1FF),
  shadow: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFC1C1FF),
  onPrimary: Color(0xFF262477),
  primaryContainer: Color(0xFF3D3C8F),
  onPrimaryContainer: Color(0xFFE1E0FF),
  secondary: Color(0xFF80DB7D),
  onSecondary: Color(0xFF003907),
  secondaryContainer: Color(0xFF00530F),
  onSecondaryContainer: Color(0xFF9BF896),
  tertiary: Color(0xFFCBCC58),
  onTertiary: Color(0xFF323200),
  tertiaryContainer: Color(0xFF494A00),
  onTertiaryContainer: Color(0xFFE8E970),
  error: Color(0xFFF2B8B5),
  errorContainer: Color(0xFF8C1D18),
  onError: Color(0xFF601410),
  onErrorContainer: Color(0xFFF9DEDC),
  background: Color(0xFF1C1B1F),
  onBackground: Color(0xFFE6E1E5),
  surface: Color(0xFF1C1B1F),
  onSurface: Color(0xFFE6E1E5),
  surfaceVariant: Color(0xFF49454F),
  onSurfaceVariant: Color(0xFFCAC4D0),
  outline: Color(0xFF938F99),
  onInverseSurface: Color(0xFF1C1B1F),
  inverseSurface: Color(0xFFE6E1E5),
  inversePrimary: Color(0xFF5555A8),
  shadow: Color(0xFF000000),
);

Map<String, String> colors = {
  'color_primary': '#5555a9',
  'color_on_primary': '#ffffff',
  'color_primary_container': '#e1e0ff',
  'color_on_primary_container': '#0e0664',
  'color_secondary': '#186d23',
  'color_on_secondary': '#ffffff',
  'color_secondary_container': '#a1f79b',
  'color_on_secondary_container': '#012104',
  'color_tertiary': '#616200',
  'color_on_tertiary': '#ffffff',
  'color_tertiary_container': '#e7e970',
  'color_on_tertiary_container': '#1d1d00',
  'color_error': '#B3261E',
  'color_error_container': '#F9DEDC',
  'color_on_error': '#FFFFFF',
  'color_on_error_container': '#410E0B',
  'color_background': '#FFFBFE',
  'color_on_background': '#1C1B1F',
  'color_surface': '#FFFBFE',
  'color_on_surface': '#1C1B1F',
  'color_surface_variant': '#E7E0EC',
  'color_on_surface_variant': '#49454F',
  'color_outline': '#79747E',
  'color_inverse_on_surface': '#F4EFF4',
  'color_inverse_surface': '#313033',
  'color_inverse_primary': '#c1c1ff',
  'color_shadow': '#000000',
  'color_palette_primary100': '#ffffff',
  'color_palette_primary99': '#fefbff',
  'color_palette_primary95': '#f1efff',
  'color_palette_primary90': '#e1e0ff',
  'color_palette_primary80': '#c1c1ff',
  'color_palette_primary70': '#a2a2fc',
  'color_palette_primary60': '#8888df',
  'color_palette_primary50': '#6e6ec4',
  'color_palette_primary40': '#5555a9',
  'color_palette_primary30': '#3d3d8f',
  'color_palette_primary20': '#262477',
  'color_palette_primary10': '#0e0664',
  'color_palette_primary0': '#000000',
  'color_palette_secondary100': '#ffffff',
  'color_palette_secondary99': '#f5ffed',
  'color_palette_secondary95': '#c6ffbd',
  'color_palette_secondary90': '#a1f79b',
  'color_palette_secondary80': '#86da81',
  'color_palette_secondary70': '#6bbe69',
  'color_palette_secondary60': '#51a251',
  'color_palette_secondary50': '#37873a',
  'color_palette_secondary40': '#186d23',
  'color_palette_secondary30': '#00530e',
  'color_palette_secondary20': '#003907',
  'color_palette_secondary10': '#012104',
  'color_palette_secondary0': '#000000',
  'color_palette_tertiary100': '#ffffff',
  'color_palette_tertiary99': '#ffffc8',
  'color_palette_tertiary95': '#f6f77d',
  'color_palette_tertiary90': '#e7e970',
  'color_palette_tertiary80': '#cacc58',
  'color_palette_tertiary70': '#afb13f',
  'color_palette_tertiary60': '#949626',
  'color_palette_tertiary50': '#7a7c05',
  'color_palette_tertiary40': '#616200',
  'color_palette_tertiary30': '#484a00',
  'color_palette_tertiary20': '#323200',
  'color_palette_tertiary10': '#1d1d00',
  'color_palette_tertiary0': '#000000',
  'color_palette_neutral100': '#FFFFFF',
  'color_palette_neutral99': '#FFFBFE',
  'color_palette_neutral95': '#F4EFF4',
  'color_palette_neutral90': '#E6E1E5',
  'color_palette_neutral80': '#C9C5CA',
  'color_palette_neutral70': '#AEAAAE',
  'color_palette_neutral60': '#939094',
  'color_palette_neutral50': '#787579',
  'color_palette_neutral40': '#605D62',
  'color_palette_neutral30': '#484649',
  'color_palette_neutral20': '#313033',
  'color_palette_neutral10': '#1C1B1F',
  'color_palette_neutral0': '#000000',
  'color_palette_neutral_variant100': '#FFFFFF',
  'color_palette_neutral_variant99': '#FFFBFE',
  'color_palette_neutral_variant95': '#F5EEFA',
  'color_palette_neutral_variant90': '#E7E0EC',
  'color_palette_neutral_variant80': '#CAC4D0',
  'color_palette_neutral_variant70': '#AEA9B4',
  'color_palette_neutral_variant60': '#938F99',
  'color_palette_neutral_variant50': '#79747E',
  'color_palette_neutral_variant40': '#605D66',
  'color_palette_neutral_variant30': '#49454F',
  'color_palette_neutral_variant20': '#322F37',
  'color_palette_neutral_variant10': '#1D1A22',
  'color_palette_neutral_variant0': '#000000',
  'color_palette_error100': '#FFFFFF',
  'color_palette_error99': '#FFFBF9',
  'color_palette_error95': '#FCEEEE',
  'color_palette_error90': '#F9DEDC',
  'color_palette_error80': '#F2B8B5',
  'color_palette_error70': '#EC928E',
  'color_palette_error60': '#E46962',
  'color_palette_error50': '#DC362E',
  'color_palette_error40': '#B3261E',
  'color_palette_error30': '#8C1D18',
  'color_palette_error20': '#601410',
  'color_palette_error10': '#410E0B',
  'color_palette_error0': '#000000',
  'color_custom_subtitle': '#000000',
  'color_custom_target': '#000000',
  'color_custom_chase': '#000000',
};