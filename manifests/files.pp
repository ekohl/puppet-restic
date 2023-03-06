# @summary manage the files backup service and timer
# @api private
class restic::files (
  String[1] $on_calendar = '*-*-* 2:00:00',
) {
  require restic

  systemd::timer { 'restic@.timer':
    timer_content   => epp('restic/restic@.timer.epp', { 'on_calendar' => $on_calendar }),
    service_content => epp('restic/restic@.service.epp', { 'user' => $restic::user }),
    require         => Class['restic'],
  }
}
