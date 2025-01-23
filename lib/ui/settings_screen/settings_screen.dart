import 'package:card_settings_ui/list/settings_list.dart';
import 'package:card_settings_ui/section/settings_section.dart';
import 'package:card_settings_ui/tile/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:ttl_camera/state/deletion_method.dart';
import 'package:ttl_camera/state/global_state.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Settings',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 20))),
      body: Watch((ctx) => SettingsList(
            contentPadding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            sections: [
              SettingsSection(
                margin: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      GlobalState()
                          .deletionMethod
                          .toggle(DeletionMethod.deleteBackground);
                    },
                    description: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        'Will delete outside of app, notify you when done',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 10),
                      ),
                    ),
                    initialValue: GlobalState().deletionMethod.signal.value ==
                        DeletionMethod.deleteBackground,
                    title: Text('Delete in background',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      GlobalState()
                          .deletionMethod
                          .toggle(DeletionMethod.deleteInApp);
                    },
                    initialValue: GlobalState().deletionMethod.signal.value ==
                        DeletionMethod.deleteInApp,
                    title: Text('Delete in app via modal',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
                    description: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        'Will show a modal to confirm deletion while app in use',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
